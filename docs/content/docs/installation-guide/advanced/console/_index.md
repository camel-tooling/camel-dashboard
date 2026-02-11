---
title: "Camel Dashboard Console"
weight: 40
aliases:
    - /docs/installation-guide/console/overview/
resources:
- src: "**oc-console-list-420*.png"
  params:
    byline: "Camel Applications"
- src: "**oc-console-detail-420*.png"
  params:
    byline: "Camel Application > Details"
- src: "**oc-console-detail-resources-420*.png"
  params:
    byline: "Camel Application > Resources"
- src: "**oc-console-detail-metrics-420*.png"
  params:
    byline: "Camel Application > Metrics"
---

This operator can work standalone and you can use the data exposed in the `CamelApp` custom resource accordingly. However it has a great fit with the [Camel Dashboard Console](https://github.com/camel-tooling/camel-dashboard-console?tab=readme-ov-file#deployment-to-openshift), which is a visual representation of the services exposed by the operator.

## Camel Dashboard Console dependencies matrix

The Camel Dashboard Console is a plugin extension of OpenShift Console exposing the data from the Camel Dashboard Operator.

Below you can find the compatibility list for its dependencies:

| Camel Dashboard Console | Openshift          | Camel Dashboard Operator |
| ----------------------- | ------------------ | ------------------------ |
| next (0.3.3)            | Openshift 4.20+    | 0.1.0                    |
| 0.3.2                   | Openshift 4.20+    | 0.1.0                    |
| 0.2.2                   | Openshift 4.19     | 0.1.0                    |
| 0.1.0                   | Openshift 4.18     | 0.0.1                    |

NOTE: the old version 0.1.0 uses the old `App` custom resource.

> WARNING: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `camel-dashboard-console.`

### Installing the Helm Chart

A [Helm](https://helm.sh) chart is available to deploy the console plugin to an OpenShift environment.

The following Helm parameters are required:

`plugin.image:` The location of the image containing the console plugin that was previously pushed

Additional parameters can be specified if desired. Consult the chart values file for the full set of supported parameters.

First, add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/) (you might have already done it if you installed the [Camel Dashboard Operator](/camel-dashboard/docs/operator)):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

Install *Camel Dashboard* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:

```bash
helm upgrade -i camel-dashboard-console camel-dashboard/camel-dashboard-console --version 0.3.2 --namespace camel-dashboard --set plugin.image=quay.io/camel-tooling/camel-dashboard-console:0.3.2
```

> NOTE: the installation procedure is still in alpha phase. Verify the latest release and change the version (ie, `0.3.2`) from the previous script accordingly.

## Overview

Once installed, the **Camel Dashboard Console** features should be accessible in the OpenShift Console.

* The *Camel Applications* page displays the list of your deployed Camel Applications. It is available as a `Workloads` tab on the `admin` view and as a navigation tab on the `developer` view.
{{% imgproc oc-console-list-420 Resize "1935x1001" %}}
{{% /imgproc %}}

* The *Camel Application* page will show informations and metrics for the chose deployed Camel Application

    * informations from the Observability Services

{{% imgproc oc-console-detail-420 Resize "1935x1001" %}}
{{% /imgproc %}}

   * Kubernetes native resources linked to the deployment, with some acces to logs, hawtio console, etc

{{% imgproc oc-console-detail-resources-420 Resize "1935x1001" %}}
{{% /imgproc %}}

   * Prometheus metrics on resources utilization for the deployment

{{% imgproc oc-console-detail-metrics-420 Resize "1935x1001" %}}
{{% /imgproc %}}
