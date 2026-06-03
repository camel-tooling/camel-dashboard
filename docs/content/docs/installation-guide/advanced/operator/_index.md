---
title: "Camel Monitor Operator"
linkTitle: "Camel Monitor Operator"
weight: 30
aliases:
  - /docs/installation-guide/operator/configuration/
---

The **Camel Monitor Operator** is a project created to simplify the management of any Camel application on a Kubernetes cluster. The tool is in charge to **monitor any Camel application** and provide a set of basic information, useful to learn how your fleet of Camel (a caravan!?) is behaving.

The project is designed to be as simple and low resource consumption as possible. It only collects the most important Camel application KPI in order to quickly identify what's going on across your Camel applications.

> NOTE: as the project is still in an experimental phase, the metrics collected can be changed at each development iteration.

> WARNING: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `camel-monitor-operator.`

## The Camel custom resource

The operator uses a simple custom resource known as `CamelMonitor` or `cmon` which stores certain metrics around your running applications. The operator detects the Camel applications you’re deploying to the cluster, identifying them in a given namespace or a given metadata label that need to be included when deploying your applications (all configurable on the operator side).

## Installation

We offer different installation methodologies: Helm, Kustomize (via `kubectl`) and OLM.

### Helm

You can use [Helm](https://helm.sh) to install the operator resources. You can install it in any namespace (we conventionally use `camel-dashboard` namespace, which, has to be created previously). The default configuration is for a cluster scoped operator (use `--set operator.global="false"` for a namespace scoped operator).


* Add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

* Confirm the addition of the repository:
```bash
$ helm repo list

NAME    URL
camel-dashboard	https://camel-tooling.github.io/camel-dashboard/charts/
```

* Install the *operator* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:
```bash
$ helm install camel-monitor-operator camel-dashboard/camel-monitor-operator -n camel-dashboard
```

You can check if the operator is running:

```bash
$ kubectl get pods -n camel-dashboard
NAME                                        READY   STATUS    RESTARTS   AGE
camel-monitor-operator-7c6bcf5576-fwn7s   1/1     Running   0          4m18s
```

### Kustomize

[Kustomize](https://kustomize.io/) provides a declarative approach to the configuration customization of a Camel Monitor Operator installation. Kustomize works either with a standalone executable or as a built-in to `kubectl`. The `/install` directory provides a series of base and overlays configuration that you can use. You can create your own overlays or customize the one available in the repository to accommodate your need.

```bash
$ kubectl create ns camel-monitor
$ kubectl apply -k github.com/camel-tooling/camel-monitor-operator/install/overlays/kubernetes/descoped?ref=v0.2.1 --server-side
```

You can specify as ref parameter the version you’re willing to install (ie, v0.2.1). The command above will install a descoped (global) operator in the `camel-monitor` namespace. This is the suggested configuration in order to manage `CamelMonitors` in all namespaces.

### OLM

Camel Monitor is also available in Operator Hub. You will need the OLM framework to be properly installed in your cluster.

```bash
$ kubectl create -f https://operatorhub.io/install/camel-monitor-operator.yaml
```

You can edit the Subscription custom resource, setting the channel you want to use. We provide an installation channel for `latest` and each major version we’re releasing (ie, `stable-v0`). This will simplify the upgrade process if you choose to perform an automatic upgrade.

> NOTE: some Kubernetes clusters such as Openshift may let you to perform the same operation from a GUI as well. Refer to the cluster instruction to learn how to perform such action from user interface.

## Configuration

There are several configuration you can apply separately to each of your Camel application. They mostly work at general level (setting an environment variable on the operator) or at application level (setting an annotation on the Deployment resource).

### Camel Application discovery

The operator is instructed to watch `Deployment` and verify if they are marked as Camel application. You will likely need to update your deployment process and include automatically a `camel.apache.org/monitor` label for all the applications you want to monitor.

> NOTE: you can configure the operator to watch for a different label setting the environment variable `LABEL_SELECTOR` in the operator Pod.

### Collect Camel metrics

The operator is designed to consume the services exposed by [Camel Observability Services component](https://camel.apache.org/components/next/others/observability-services.html).

It will works also when no services are exposed, but it won't be able to collect any meaningful metrics (likely only the status and the number of replicas).

### Camel annotations synchronization

As you will discover in the configuration chapter, you can provide specific configuration for each `CamelMonitor`. In order to keep the operator in synch with any deployment tool, you should therefore annotate the backing deployment object (ie, the `Deployment`) with such specific configuration. The operator will automatically synchronize any annotation prefixed with `camel.apache.org`.

### Configure the metrics polling

You can watch the metrics evolving as long as the application is running, for example via `-w` parameter:

```bash
$ kubectl get camelmonitors -w

NAME              INFO                                           PHASE    REPLICAS   HEALTHY   MONITORED   MEMORY PRESSURE   CPU PRESSURE   EXCHANGE SLI   LAST EXCHANGE
camel-app-413     Main - 4.13.0-SNAPSHOT (4.13.0-SNAPSHOT)       Running  1          true      true        False             False          OK             2m42s
camel-app-sb      Spring-Boot - 3.4.3 (4.11.0)                   Running  1          false     true        False             False          Error
camel-app-quarkus Quarkus - 3.33.1 (4.17.0)                      Running  1          true      true        False             True           Warning        1m30s
...
```

The `CamelMonitors` are polled every minute by default. It should be enough in most cases, as the project is meant to be a lightweight monitoring tool. However, you can change this configuration if you want a more or less reactive polling. You can configure this value both at operator level (which would affect all the applications) or at single application level.

#### Operator level

You can setup the environment variables `POLL_INTERVAL_SECONDS` with the number of seconds between each metrics polling.

> NOTE: this will affect all your applications. Setting it a low value can reduce the performances of both the operator and the same Camel applications which will need to use compute resources to read from the HTTP service.

#### Application level

You can add an annotation to the `Deployment` resource, `camel.apache.org/polling-interval-seconds` with the value you want.

> NOTE: although this configuration will only affect the single application, consider the right balance to avoid affecting the application performances.

### Configure the SLI Exchange error and warning percentage

The operator is in charge to automatically calculate the success rate percentage of exchanges in the last polling interval time. It has some default configuration and will return a `Success`, `Warning` or `Error` status if it detects that the failure of exchanges during the interval exceeds the thresholds. It returns an `Error` when the failure exceed the 5% of exchanges failed, `Warning` if the failure is above 10%, `Success`. However, these values can be configured.

#### Operator level

You can setup the environment variables `SLI_ERR_PERCENTAGE` and `SLI_WARN_PERCENTAGE`. It requires an `int` value.

#### Application level

You can add an annotation to the `Deployment` resource, `camel.apache.org/sli-exchange-error-percentage` and `camel.apache.org/sli-exchange-warning-percentage` with the value expected for that specific application only.

### Configure the observability services port

The operator is able to discover applications thanks to the presence of the `camel-observability-services` component. By default this component exposes the metrics on port `9876` (which is also the operator default if you don't configure it). However this value can be changed by the user to any other port (including the regular business service port). You can configure is both at Operator or Application level.

#### Operator level

You can setup the environment variables `OBSERVABILITY_PORT` with the number of the port where the operator has to get the metrics.

#### Application level

You can add an annotation to the `Deployment` resource, `camel.apache.org/observability-services-port` with the value expected for that specific application only.

### Include Prometheus PodMonitor

The presence of `camel-observability-services` leverages Micrometer Prometheus technology. The exposure of the metrics endpoint enables the possibility for the operator to include the custom resource expected by Prometheus operator automatically. The operator is able to detect the presence of such capability on the cluster, and, by default, include a `PodMonitor` associated with the Camel application monitored by the dashboard.

Such a `PodMonitor` can be eventually used by the final user for more [advanced monitoring activities](https://prometheus-operator.dev/docs/developer/getting-started/#using-podmonitors).

#### Operator level

You can setup the environment variable `CREATE_PROMETHEUS_POD_MONITOR` (by default it is enabled). It must be `true` to enable the creation of the Prometheus custom resource. Remove the variable or set to any other value to disable the feature.

You should also set the environment variable `PROMETHEUS_LABEL` in order to configure all the `PodMonitor` with the proper label selector expected by your existing `Prometheus` instance. The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/prometheus=camel-dashboard-operator`. If you therefore want to create a dedicated instance to monitor all Camel Dashboard applications, you can configure your `Prometheus` to select such a default label.

#### Application level

Not available at the moment. Feel free to open a change request to enable this in future releases.

### Include Grafana Dashboard

The operator is also in charge to create a `GrafanaDashboard` custom resource equipped with a series of opinionated metrics for each Camel application it discovers. The result is an automatic dashboard that can be browsed in [Grafana](https://grafana.com/) monitoring tool (which has to be available in the cluster).

> NOTE: this feature is experimental.

When the operator detects the exposure of the Prometheus metrics endpoint and the presence of an existing Grafana operator (via the availability of `GrafanaDashboard` custom resource), it will create a new dashboard with the same name of the application. This will be picked by the `Grafana` instance and exposed in its interface.

#### Operator level

You can setup the environment variable `CREATE_GRAFANA_MONITOR` (by default it is enabled). It must be `true` to enable the creation of the `GrafanaDashboard` custom resource. Remove the variable or set to any other value to disable the feature. Every dashboard created needs to setup the datasource to use: we control this configuration via the environment variable `GRAFANA_DS` which defaults to the value `prometheus`. If your Prometheus datasource has a different name, you'll need to change the variable accordingly.

You should also set the environment variable `GRAFANA_LABEL` in order to configure all the dashboards created with the proper label selector expected by your existing `Grafana` instance. The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/grafana=camel-dashboard-operator`. If you therefore want to create a dedicated instance to monitor all Camel Dashboard applications, you can configure your `Grafana` to select such a default label.

#### Application level

Not available at the moment. Feel free to open a change request to enable this in future releases.

### Include Alert PrometheusRule

The operator is also in charge to create a single `PrometheusRule` custom resource equipped with a series of opinionated Camel alerts that could be used to integrate in any SRE system via [Prometheus Alert Manager](https://prometheus.io/docs/alerting/latest/alertmanager/).

When the operator detects the existence of the Prometheus custom resources, it will create an alert named `camel-dashboard-alerts` in the same namespace where the operator is installed (the process is the same regardless if the operator is global or namespace scoped).

#### Operator level

You can setup the environment variable `CREATE_PROMETHEUS_RULE` (by default it is enabled). It must be `true` to enable the creation of the `PrometheusRule` custom resource. Remove the variable or set to any other value to disable the feature.

You should also set the environment variable `PROMETHEUS_RULE_LABEL` in order to configure the alert rules created with the proper label selector expected by your existing `Prometheus` instance (i.e., via `.spec.ruleSelector.matchLabels`). The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/alerts=camel-dashboard-operator` if none is specified.

#### Application level

Not available at the moment. Feel free to open a change request to enable this in future releases.
