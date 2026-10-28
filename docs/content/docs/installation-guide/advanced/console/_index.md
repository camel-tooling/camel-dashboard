---
title: "Camel Dashboard Console"
weight: 40
aliases:
    - /docs/installation-guide/console/overview/
resources:
- src: "**oc-console-list-422*.png"
  params:
    byline: "Camel Applications"
- src: "**oc-console-detail-1-422*.png"
  params:
    byline: "Camel Application > Details 1"
- src: "**oc-console-detail-2-422*.png"
  params:
    byline: "Camel Application > Details 2"
- src: "**oc-console-detail-resources-422*.png"
  params:
    byline: "Camel Application > Resources"
- src: "**oc-console-detail-metrics-422*.png"
  params:
    byline: "Camel Application > Metrics"
---

This operator can work standalone and you can use the data exposed in the `CamelMonitor` custom resource accordingly. However it has a great fit with the [Camel Dashboard Console](https://github.com/camel-tooling/camel-dashboard-console?tab=readme-ov-file#deployment-to-openshift), which is a visual representation of the services exposed by the operator.

## Automatic deployment via OLM

When the Camel Monitor Operator is installed via OLM in **global mode** (watching all namespaces), the Camel Dashboard Console is **automatically deployed** on OpenShift — no separate installation step is required.

The operator detects the presence of the `ConsolePlugin` CRD on the cluster and automatically creates and manages all required resources (Deployment, Service, ConfigMap and ConsolePlugin CR) in the operator namespace. The console plugin image is bundled with the OLM catalog entry.

The operator continuously reconciles these resources, so any manual modification or accidental deletion will be automatically corrected.

The console plugin is deployed but **not activated by default**. After installation, enable it via the notification banner that appears in the OpenShift web console, or manually in **Administration > Cluster Settings > Configuration > Console operator > Console plugins**.

On operator uninstall, the console resources are cleaned up automatically. However, you should **disable the console plugin before uninstalling** the operator, as the cluster will otherwise still consider the plugin as enabled even after its resources have been removed.

> NOTE: Automatic deployment only applies to the **global** OLM installation mode. For namespace-scoped installations, or non-OLM installations (Helm, Kustomize), use the Helm chart method described below.

## Camel Dashboard Console dependencies matrix

The Camel Dashboard Console is a plugin extension of OpenShift Console exposing the data from the Camel Monitor Operator.

Below you can find the compatibility list for its dependencies:

| Camel Dashboard Console | Openshift          | Camel Monitor Operator |
| ----------------------- | ------------------ | ------------------------ |
| next (1.0.1)            | Openshift 4.22     | 1.0.0                    |
| 1.0.0                   | Openshift 4.22     | 1.0.0                    |
| 0.5.0                   | Openshift 4.21+    | 0.2.1                    |
| 0.4.1                   | Openshift 4.21+    | 0.1.0                    |
| 0.3.2                   | Openshift 4.20     | 0.1.0                    |
| 0.2.2                   | Openshift 4.19     | 0.1.0                    |
| 0.1.0                   | Openshift 4.18     | 0.0.1                    |

NOTE: console versions up to 0.5.0 also support the legacy `CamelApp` custom resource, which is no longer supported starting 1.0.0. The `camelAppRbac` chart value was removed in the same release: move any `CamelApp` permissions to `camelMonitorRbac` when upgrading.

> WARNING: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `camel-dashboard-console.`

### Installing the Helm Chart (non-OLM)

A [Helm](https://helm.sh) chart is available to deploy the console plugin to an OpenShift environment.

The following Helm parameters are required:

`plugin.image:` The location of the image containing the console plugin that was previously pushed

Additional parameters can be specified if desired. Consult the chart values file for the full set of supported parameters.

> NOTE: the chart deploys a `NetworkPolicy` by default (`plugin.networkPolicy.enabled: true`), allowing ingress on the plugin port (`9443`) and denying all egress. Set `plugin.networkPolicy.enabled=false` if the plugin needs other network flows or if network policies are managed separately.

First, add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/) (you might have already done it if you installed the [Camel Monitor Operator](/camel-dashboard/docs/operator)):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

Install *Camel Dashboard* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:

```bash
helm upgrade -i camel-dashboard-console camel-dashboard/camel-dashboard-console --version 1.0.0 --namespace camel-dashboard --set plugin.image=quay.io/camel-tooling/camel-dashboard-console:1.0.0
```

> NOTE: 1.0.0 requires OpenShift 4.22. Refer to the compatibility matrix above to pick the release matching your cluster.

## Overview

Once installed, the **Camel Dashboard Console** features should be accessible in the OpenShift Console.

* The *Camel Applications* page lists the deployed Camel Applications with their status, Camel health, runtime provider, Camel version, upgrade availability and age. It is available as a `Workloads` tab on the `admin` view and as a navigation tab on the `developer` view.

  The health counters next to the title (*Healthy*, *Degraded*, *Critical*) summarize all applications and act as filters when clicked. The filter menu also narrows the list by name, Camel health, runtime provider, Camel version, status or upgrade availability.

{{% imgproc oc-console-list-422 Resize "1935x1001" %}}
{{% /imgproc %}}

* The *Camel Application* page shows details and metrics for the selected Camel Application. The `Details` tab shows health, service level indicator (success rate, exchange counts), resource pressure and pods summary from the Observability Services, plus runtime, process and endpoint information for each pod.

{{% imgproc oc-console-detail-1-422 Resize "1798x1029" %}}
{{% /imgproc %}}
{{% imgproc oc-console-detail-2-422 Resize "1798x1029" %}}
{{% /imgproc %}}

* The `Resources` tab lists the Kubernetes native resources linked to the deployment, with access to logs and the Hawtio console.

{{% imgproc oc-console-detail-resources-422 Resize "1935x1001" %}}
{{% /imgproc %}}

* The `Metrics` tab shows Prometheus metrics on memory, CPU, filesystem and network usage for the deployment.

{{% imgproc oc-console-detail-metrics-422 Resize "1935x1001" %}}
{{% /imgproc %}}
