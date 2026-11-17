---
title: "Environment variables"
linkTitle: "Environment variables"
weight: 40
description: "Reference of all the environment variables supported by the Camel Monitor Operator"
---

The Camel Monitor Operator is configured through environment variables set on the operator `Deployment`. This page lists all of them. You can find a more detailed explanation of each feature in the [configuration](/camel-dashboard/docs/configuration/) page.

## How to set a variable

The way you set a variable depends on how you installed the operator:

* **Helm**: use the `operator.extraEnv` value.

```yaml
operator:
  extraEnv:
    - name: POLL_INTERVAL_SECONDS
      value: "30"
```

* **Kustomize**: add a patch to the operator `Deployment` in your overlay.

```yaml
- op: add
  path: /spec/template/spec/containers/0/env/-
  value:
    name: POLL_INTERVAL_SECONDS
    value: "30"
```

* **OLM**: use the `.spec.config.env` field of the `Subscription`.

```yaml
spec:
  config:
    env:
      - name: POLL_INTERVAL_SECONDS
        value: "30"
```

* **Any installation**: patch the running `Deployment` directly (the change may be reverted by the tool managing the installation).

```bash
$ kubectl set env deployment/camel-monitor-operator POLL_INTERVAL_SECONDS=30 -n camel-dashboard
```

> NOTE: the operator reads the variables at startup only. Any change requires a restart of the operator Pod, which happens automatically when the `Deployment` is changed.

## Operator

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `WATCH_NAMESPACE` | string | none (required) | Namespace(s) the operator watches. An empty value means all namespaces (global operator). You can provide a single namespace or a comma separated list. The variable must exist, even when empty. See [installation topologies](/camel-dashboard/docs/installation-guide/advanced/operator/#installation-topologies). |
| `NAMESPACE` | string | none | Namespace where the operator is running. It is normally injected from the Pod `metadata.namespace` and should not be changed. |
| `OPERATOR_ID` | string | empty | Identifier of the operator. When set, it is used as the name of the leader election lock (`<OPERATOR_ID>-lock`). |
| `LOG_LEVEL` | string | `info` | Log level of the operator. Either `error`, `info`, `debug` or an integer representing the log verbosity. An invalid value prevents the operator from starting. |
| `LABEL_SELECTOR` | string | `camel.apache.org/monitor` | Label used to discover the Camel applications to monitor. |

## Metrics polling and SLI

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `POLL_INTERVAL_SECONDS` | int | `60` | Number of seconds between each metrics polling. |
| `SLI_ERR_PERCENTAGE` | int | `5` | Percentage of failed exchanges above which the SLI is reported as error. |
| `SLI_WARN_PERCENTAGE` | int | `10` | Percentage of failed exchanges above which the SLI is reported as warning. |
| `MAX_IDLE_SEC` | int | `60` | Maximum number of seconds an application is expected to be idle. It is used as a threshold in the generated Grafana dashboard. |

## Observability services

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `OBSERVABILITY_HEALTH_PORTS` | comma separated list | `9876,8080` | Ports where the operator looks for the health endpoint. |
| `OBSERVABILITY_METRICS_PORTS` | comma separated list | `9876,8080` | Ports where the operator looks for the metrics endpoint. |
| `OBSERVABILITY_HEALTH_ENDPOINTS` | comma separated list | `observe/health,q/health,actuator/health` | Paths where the operator looks for the health endpoint. |
| `OBSERVABILITY_METRICS_ENDPOINTS` | comma separated list | `observe/metrics,q/metrics,actuator/prometheus` | Paths where the operator looks for the metrics endpoint. |

> NOTE: the values are tried in the order they are provided. For performance reasons it is better to configure a single value.

## Prometheus and Grafana

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CREATE_PROMETHEUS_POD_MONITOR` | boolean | disabled | Set to `true` to create a `PodMonitor` for each monitored application. Requires the Prometheus operator custom resources. |
| `PROMETHEUS_LABEL` | `key=value` | `camel.apache.org/prometheus=camel-monitor-operator` | Label added to every `PodMonitor` created, to match the selector of your `Prometheus` instance. |
| `CREATE_PROMETHEUS_RULE` | boolean | disabled | Set to `true` to create the `PrometheusRule` holding the Camel alerts. Requires the Prometheus operator custom resources. |
| `PROMETHEUS_RULE_LABEL` | `key=value` | `camel.apache.org/alerts=camel-monitor-operator` and `app=camel-monitor` | Label added to the `PrometheusRule` created, to match the rule selector of your `Prometheus` instance. |
| `CREATE_GRAFANA_DASHBOARD` | boolean | disabled | Set to `true` to create a `GrafanaDashboard` for each monitored application. Requires the Grafana operator custom resources. |
| `GRAFANA_LABEL` | `key=value` | `camel.apache.org/grafana=camel-monitor-operator` | Label added to every `GrafanaDashboard` created, to match the selector of your `Grafana` instance. |
| `GRAFANA_DS` | string | `prometheus` | Name of the Grafana datasource used by the dashboards created. |

> NOTE: the boolean variables enable the feature only when the value is exactly `true`. A missing variable or any other value disables the feature. The Kustomize and OLM installations provide `CREATE_PROMETHEUS_POD_MONITOR`, `CREATE_PROMETHEUS_RULE` and `CREATE_GRAFANA_DASHBOARD` set to `true`.

> NOTE: the label variables accept a single label formatted as `key=value`. The label is added to the default ones. A value which cannot be parsed is ignored.

## Camel version upgrade check

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CHECK_VERSION_UPGRADE` | boolean | disabled | Set to `true` to check if a new Camel version is available for each monitored application. All the installation procedures provide this variable set to `true`. |
| `CAMEL_MAIN_MAVEN_META_URL` | URL | `https://repo1.maven.org/maven2/org/apache/camel/camel-core/maven-metadata.xml` | Maven metadata used to find the latest Camel Main version. |
| `CAMEL_QUARKUS_MAVEN_META_URL` | URL | `https://repo1.maven.org/maven2/io/quarkus/platform/quarkus-camel-bom/maven-metadata.xml` | Maven metadata used to find the latest Camel Quarkus version. |
| `CAMEL_SPRING_BOOT_MAVEN_META_URL` | URL | `https://repo1.maven.org/maven2/org/apache/camel/springboot/camel-spring-boot-bom/maven-metadata.xml` | Maven metadata used to find the latest Camel Spring Boot version. |

## Performance tuning

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `CLIENT_QPS` | float | `20` | Queries per second allowed by the client-side throttling of the operator Kubernetes client. |
| `CLIENT_BURST` | int | `200` | Burst allowed by the client-side throttling of the operator Kubernetes client. |
| `MAX_CONCURRENT_RECONCILES` | int | `1` | Maximum number of `CamelMonitor` resources reconciled concurrently. |

> NOTE: a numeric variable which cannot be parsed is ignored and the default value is used instead.

## OpenShift console plugin

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `OPENSHIFT_CONSOLE_PLUGIN_IMAGE` | string | none | Container image of the [Camel Dashboard Console](/camel-dashboard/docs/installation-guide/advanced/console/) plugin. When set, and the `ConsolePlugin` API is available in the cluster, the operator deploys the console plugin. The OLM installation provides this variable. |
