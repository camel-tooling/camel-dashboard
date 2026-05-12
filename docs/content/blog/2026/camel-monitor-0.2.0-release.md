---
title: "Camel Monitor Operator 0.2.0 release"
linkTitle: "Camel Monitor Operator 0.2.0 release"
date: 2026-05-12
author: '[Pasquale Congiusti](https://github.com/squakez)'
tags: ["release", "console", "camel", "openshift", "dashboard", "monitor"]
icon: "rocket"
aliases:
    /blog/2026/camel-monitor-operator-0-2-0-release/
---

We're pleased to announce the availability of **Camel Monitor operator version 0.2.0**. We decided to rename the old Camel Dashboard Operator in order to better clarify the intent of this tool. While the dashboard is something we're still providing (via plugin UI), we thought that renaming the operator as more generically `Camel Monitor` was the right thing to do.

We want to give you the maximum flexibility and let use only the operator to perform any monitoring activity and leverage the UI plugin for dashboards.

## CRD renaming

With the operator rename we thought we had to rename the custom resource we use as well. From now on we will refer to `CamelMonitor` (shortname, `cmon`) custom resource. The logic hasn't changed. Whenever an operator discover a Camel application, it will create the related `CamelMonitor`. In this release we've added a few more metrics as illustrated in some following chapter.

## Support CronJob

From this version onward the operator will be able to monitor also Camel applications deployed as `CronJob`.

## Support KnativeService

Beside `Deployment` and `CronJob` we have also enabled the possibility to monitor any other custom resource that is finally producing a `Deployment` object baking a Camel application. It's the case of Knative `Service`. So, even if you deal with any third party custom resource to manage Camel applications, if the final result is a `Deployment`, then, the Camel Monitor operator will be able to discover and manage it.

## Camel K operator integration

Camel K is [the best way to deploy Camel cloud natives applications](https://camel.apache.org/camel-k/). We are planning to make the Camel K operator and the Camel Monitor operator more integrated in order to provide a great experience both for deploying and for monitoring a Camel application in the cloud. In version 2.10 of Camel K it was introduced a mechanism to simplify the discovery of applications deployed via Camel K.

If you have both Camel K and Camel Monitor running in your cloud, release a Camel K `Integration` and you will get automatically a `CamelMonitor` with all the metrics you need to monitor your `Integration`.

## Added new metrics

We have introduced a few more resource scraping. This is the completed list of the new available information:

- ProcessCPUUsed: How much CPU (in millicores) the process is consuming
- ProcessCPUMax: How much CPU (in millicores) the process is allowed to consume
- JVMMemoryUsed: How much memory (in bytes) the process is consuming
- JVMMemoryMax: How much memory (in bytes) the process is allowed to consume
- HasMemoryPressure: If true indicates that the memory usage is approximating dangerously to the cap
- HasCPUPressure: If true indicates that the CPU usage is approximating dangerously to the cap

The last two flags are a great way to immediately check if a giving application is suffering some kind of resource pressure.

## Support Prometheus stack

In this release we have dedicated to support more strictly the Prometheus stack: [Prometheus](https://prometheus-operator.dev/), [Grafana](https://grafana.com/) and [AlertManager](https://prometheus.io/docs/alerting/latest/alertmanager/).

The presence of `camel-observability-services` leverages Micrometer Prometheus technology. The exposure of the metrics endpoint enables the possibility for the operator to include the custom resource expected by Prometheus stack automatically.

If you have all the stack available in the cluster, you will be able to get automatically all custom resources required by the Prometheus stack to provide a deep level of monitoring and alerting.

## PodMonitor

The operator is able to detect the presence of the Prometheus operator on the cluster, and, by default, include a `PodMonitor` associated with the Camel application monitored by the dashboard. Such a `PodMonitor` can be eventually used by the final user for more [advanced monitoring activities](https://prometheus-operator.dev/docs/developer/getting-started/#using-podmonitors).

You can setup the environment variable `CREATE_PROMETHEUS_POD_MONITOR` (by default it is enabled). It must be `true` to enable the creation of the Prometheus custom resource. Remove the variable or set to any other value to disable the feature.

You should also set the environment variable `PROMETHEUS_LABEL` in order to configure all the `PodMonitor` with the proper label selector expected by your existing `Prometheus` instance. The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/prometheus=camel-monitor-operator`. If you therefore want to create a dedicated instance to monitor all Camel Dashboard applications, you can configure your `Prometheus` to select such a default label.

## GrafanaDashboards

The operator is also in charge to create a `GrafanaDashboard` custom resource equipped with a series of opinionated metrics for each Camel application it discovers. The result is an automatic dashboard that can be browsed in [Grafana](https://grafana.com/) monitoring tool (which has to be available in the cluster).

> NOTE: this feature is experimental.

When the operator detects the exposure of the Prometheus metrics endpoint and the presence of an existing Grafana operator (via the availability of `GrafanaDashboard` custom resource), it will create a new dashboard with the same name of the application. This will be picked by the `Grafana` instance and exposed in its interface.

You can setup the environment variable `CREATE_GRAFANA_MONITOR` (by default it is enabled). It must be `true` to enable the creation of the `GrafanaDashboard` custom resource. Remove the variable or set to any other value to disable the feature. Every dashboard created needs to setup the datasource to use: we control this configuration via the environment variable `GRAFANA_DS` which defaults to the value `prometheus`. If your Prometheus datasource has a different name, you'll need to change the variable accordingly.

You should also set the environment variable `GRAFANA_LABEL` in order to configure all the dashboards created with the proper label selector expected by your existing `Grafana` instance. The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/grafana=camel-monitor-operator`. If you therefore want to create a dedicated instance to monitor all Camel Dashboard applications, you can configure your `Grafana` to select such a default label.

## PrometheusRule

The operator is also in charge to create a single `PrometheusRule` custom resource equipped with a series of opinionated Camel alerts that could be used to integrate in any SRE system via [Prometheus Alert Manager](https://prometheus.io/docs/alerting/latest/alertmanager/).

When the operator detects the existence of the Prometheus custom resources, it will create an alert named `camel-dashboard-alerts` in the same namespace where the operator is installed (the process is the same regardless if the operator is global or namespace scoped).

You can setup the environment variable `CREATE_PROMETHEUS_RULE` (by default it is enabled). It must be `true` to enable the creation of the `PrometheusRule` custom resource. Remove the variable or set to any other value to disable the feature.

You should also set the environment variable `PROMETHEUS_RULE_LABEL` in order to configure the alert rules created with the proper label selector expected by your existing `Prometheus` instance (i.e., via `.spec.ruleSelector.matchLabels`). The environment variable expect a single label formatted as `key=value`. By default, the operator will configure a label as `camel.apache.org/alerts=camel-monitor-operator` if none is specified.
