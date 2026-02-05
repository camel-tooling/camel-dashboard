---
title: "Camel Dashboard Operator"
linkTitle: "Camel Dashboard Operator"
weight: 30
aliases:
  - /docs/installation-guide/operator/configuration/
---

The **Camel Dashboard Operator** is a project created to simplify the management of any Camel application on a Kubernetes cluster. The tool is in charge to **monitor any Camel application** and provide a set of basic information, useful to learn how your fleet of Camel (a caravan!?) is behaving.

The project is designed to be as simple and low resource consumption as possible. It only collects the most important Camel application KPI in order to quickly identify what's going on across your Camel applications.

> NOTE: as the project is still in an experimental phase, the metrics collected can be changed at each development iteration.

> WARNING: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `camel-dashboard-operator.`

## The Camel custom resource

The operator uses a simple custom resource known as `CamelApp` or `capp` which stores certain metrics around your running applications. The operator detects the Camel applications you’re deploying to the cluster, identifying them in a given namespace or a given metadata label that need to be included when deploying your applications (all configurable on the operator side).

## Installation

You can use [Helm](https://helm.sh) to install the operator resources. You can install it in any namespace (we conventionally use `camel-dashboard` namespace, which, has to be created previously). The default configuration is for a cluster scoped operator (use `--set operator.global="false"` for a namespace scoped operator).


* Add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

* Confirm the addition of the repository:
```bash
$ helm repo list

NAME    URL                                   
camel-tooling	https://camel-tooling.github.io/camel-dashboard/charts/
```

* Install the *operator* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:
```bash
$ helm install camel-dashboard-operator camel-dashboard/camel-dashboard-operator --version 0.1.0 -n camel-dashboard --set operator.image=quay.io/camel-tooling/camel-dashboard-operator:0.1.0
```

> NOTE: The installation procedure is still in alpha phase. Verify the latest release and change the version (ie, `0.1.0`) from the previous script accordingly.

You can check if the operator is running:

```bash
$ kubectl get pods -n camel-dashboard
NAME                                        READY   STATUS    RESTARTS   AGE
camel-dashboard-operator-7c6bcf5576-fwn7s   1/1     Running   0          4m18s
```

## Configuration

There are several configuration you can apply separately to each of your Camel application. They mostly work at general level (setting an environment variable on the operator) or at application level (setting an annotation on the Deployment resource).

### Camel Application discovery

The operator is instructed to watch `Deployment` and verify if they are marked as Camel application. You will likely need to update your deployment process and include automatically a `camel.apache.org/app` label for all the applications you want to monitor.

NOTE: you can configure the operator to watch for a different label setting the environment variable `LABEL_SELECTOR` in the operator Pod.

### Collect Camel metrics

The operator is designed to consume the services exposed by [Camel Observability Services component](https://camel.apache.org/components/next/others/observability-services.html).

It will works also when no services are exposed, but it won't be able to collect any meaningful metrics (likely only the status and the number of replicas).

### Camel annotations synchronization

As you will discover in the configuraton chapter, you can provide specific configuration for each `CamelApp`. In order to keep the operator in synch with any deployment tool, you should therefore annotate the backing deployment object (ie, the `Deployment`) with such specific configuration. The operator will automatically synchronize any annotation prefixed with `camel.apache.org`.

### Configure the metrics polling

You can watch the metrics evolving as long as the application is running, for example via `-w` parameter:

```bash
$ kubectl get camelapps -w

NAME                PHASE     LAST EXCHANGE   EXCHANGE SLI   IMAGE                                  REPLICAS   INFO
...
camel-app-413       Running   8m32s           OK             squakez/cdb:4.13                       1          Main - 4.13.0-SNAPSHOT (4.13.0-SNAPSHOT)
camel-app-main      Running                   OK             docker.io/squakez/db-app-main:1.0      1          Main - 4.11.0 (4.11.0)
camel-app-quarkus   Running                   Warning        docker.io/squakez/db-app-quarkus:1.0   1
camel-app-sb        Running                   Error          docker.io/squakez/db-app-sb:1.0        1          Spring-Boot - 3.4.3 (4.11.0)
```

The `CamelApp` are polled every minute by default. It should be enough in most cases, as the project is really a dashboard and not a proper monitoring tool. However, you can change this configuration if you want a more or less reactive polling. You can configure this value both at operator level (which would affect all the applications) or at single application level.

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