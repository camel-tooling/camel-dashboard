---
title: "Configuration"
weight: 30
aliases:
  - /docs/configuration/
---

## The Camel custom resource

The operator uses a simple custom resource known as `CamelMonitor` or `cmon` which stores certain metrics around your running applications. The operator detects the Camel applications you’re deploying to the cluster, identifying them in a given namespace or a given metadata label that need to be included when deploying your applications (all configurable on the operator side).

## Configuration

There are several configuration you can apply separately to each of your Camel application. They mostly work at general level (setting an environment variable on the operator) or at application level (setting an annotation on the Deployment resource).

### Camel Application discovery

The operator is instructed to watch `Deployment` and verify if they are marked as Camel application. You will likely need to update your deployment process and include automatically a `camel.apache.org/monitor` label for all the applications you want to monitor.

> NOTE: you can configure the operator to watch for a different label setting the environment variable `LABEL_SELECTOR` in the operator Pod.

### Collect Camel metrics

The operator is designed to consume the services exposed by [Camel Observability Services component](https://camel.apache.org/components/next/others/observability-services.html). This component is a lightweight collection of existing components and it provides conventional values which makes the integration with Camel Monitor operator as zero configuration.

The Camel Monitor operator will also work when you provide `camel-health` and `camel-micrometer-prometheus` (and relative runtime extensions), but it may require some configuration on the application to let the Camel Monitor operator know how to reach the metrics endpoints.

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

### Configure the observability services ports

The operator is able to discover applications thanks to the presence of the `camel-observability-services` component or the health and metrics components provided separately in the application. By default this component exposes the health and metrics on port `9876` (which is also the operator default if you don't configure it). However this value can be changed by the user to any other port (including the regular business service port). You can configure it both at Operator or Application level.

If the operator does not find any available service on the conventional port, and no one else was configured explicitly, it will also try on `8080`, which is the default when you're not using the `camel-observability-services`.

#### Operator level

You can setup the environment variables `OBSERVABILITY_HEALTH_PORTS` and `OBSERVABILITY_METRICS_PORTS` with the number of the ports where the operator has to get the health and metrics. You can provide more than a single configuration (comma separated), although, for performance reason it is better to use only one.

#### Application level

You can add an annotation to the `Deployment` resource, `camel.apache.org/health-ports` and `camel.apache.org/metrics-ports` with the value expected for that specific application only. You can provide more than a single configuration (comma separated), although, for performance reason it is better to use only one.

### Configure the observability services metrics and health endpoints

Any application is expected to expose, by Camel default convention, the metrics and health endpoints in `/observe/metrics` and `/observe/health` respectively. However this may not be always true and it can change, in particular for those existing apps that follow the specific runtime convention (Quarkus default is `/q/` base path, Springboot is `/actuator`). You can configure them both at Operator or Application level.

By default, the endpoints will try first the Camel convention, the Quarkus one and finally the Spring Boot one. In general you can provide more than a single configuration (comma separated), although, for performance reason it is better to use only one.

#### Operator level

You can setup the environment variables `OBSERVABILITY_METRICS_ENDPOINTS` and `OBSERVABILITY_HEALTH_ENDPOINTS` respectively when all your applications are expected to expose those endpoints in a different location from the default values. You can provide a comma separated value.

#### Application level

You can add an annotation to the `Deployment` resource, `camel.apache.org/metrics-endpoints` and `camel.apache.org/health-endpoints` respectively. You can provide a comma separated value.

### Include Prometheus PodMonitor

The presence of `camel-observability-services` leverages Micrometer Prometheus technology. The exposure of the metrics endpoint enables the possibility for the operator to include the custom resource expected by Prometheus operator automatically. The operator is able to detect the presence of such capability on the cluster, and, by default, include a `PodMonitor` associated with the Camel application monitored by the dashboard.

Such a `PodMonitor` can be eventually used by the final user for more [advanced monitoring activities](https://prometheus-operator.dev/docs/developer/getting-started/#using-podmonitors). The final user has to provide the Prometheus operator installation before the Camel Monitor operator. When the installation happens after, then, a Camel Monitor operator restart is required.

> NOTE: in certain clusters (for example Openshift) you won't require to install the Prometheus operator as it works with the UWM by default, when this enabled on the cluster and the namespace (project) where the application is running.

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

### Check the availability of a new Camel version

When you're running many applications you may want to have an automatic check and verify the ones that may require an upgrade because Camel has released a new version. The operator is able to detect any new release and report as a condition into each of the monitored `CamelMonitor` custom resources.

The condition is named "UpgradeAvailable" and will report `true` or `false` with a message specifying which is the new version available.

#### Operator level

You can setup the environment variable `CHECK_VERSION_UPGRADE` (by default it is enabled). It must be `true` to enable the monitoring of a Camel version upgrade. Remove the variable or set to any other value to disable the feature. You can also control the Maven repository to access by adding the following environment variables to the operator Deployment (in parenthesis the default value, when the variable is not specified):

- CAMEL_MAIN_MAVEN_META_URL (`https://repo1.maven.org/maven2/org/apache/camel/camel-core/maven-metadata.xml`)
- CAMEL_QUARKUS_MAVEN_META_URL (`https://repo1.maven.org/maven2/io/quarkus/platform/quarkus-camel-bom/maven-metadata.xml`)
- CAMEL_SPRING_BOOT_MAVEN_META_URL (`https://repo1.maven.org/maven2/org/apache/camel/springboot/camel-spring-boot-bom/maven-metadata.xml`)

The operator Pod must be able to reach those endpoints to make the feature work as expected.

#### Application level

Not available at the moment. Feel free to open a change request to enable this in future releases.
