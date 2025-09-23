---
title: "Camel Dashboard Console"
weight: 40
resources:
- src: "**oc-console-list-419*.png"
  params:
    byline: "Camel Applications List"
- src: "**oc-console-details-419*.png"
  params:
    byline: "Camel Application Details"
- src: "**oc-console-resources-419*.png"
  params:
    byline: "Camel Application > Resources"
- src: "**oc-console-metrics-419*.png"
  params:
    byline: "Camel Application > Metrics"
---

This operator can work standalone and you can use the data exposed in the `CamelApp` custom resource accordingly. However it has a great fit with the [Camel Dashboard Console](https://github.com/camel-tooling/camel-dashboard-console?tab=readme-ov-file#deployment-to-openshift), which is a visual representation of the services exposed by the operator.

## Camel Dashboard Console dependencies matrix

The Camel Dashboard Console is a plugin extension of OpenShift Console exposing the data from the Camel Dashboard Operator.

Below you can find the compatibility list for its dependencies:

| Camel Dashboard Console | Openshift          | Camel Dashboard Operator |
| ----------------------- | ------------------ | ------------------------ |
| next (0.2.1)            | Openshift 4.19     | 0.1.0                    |
| 0.2.0                   | Openshift 4.19     | 0.1.0                    |
| 0.1.0                   | Openshift 4.18     | 0.0.1                    |

NOTE: the old version 0.1.0 uses the old `App` custom resource.

## Installation

A [Helm](https://helm.sh) chart is available to deploy the console plugin to an OpenShift environment.

The following Helm parameters are required:

`plugin.image:` The location of the image containing the console plugin that was previously pushed

Additional parameters can be specified if desired. Consult the chart values file for the full set of supported parameters.

### Installing the Helm Chart

First, add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/) (you might have already done it if you installed the [Camel Dashboard Operator](/camel-dashboard/docs/operator)):
```
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

Install the chart using the name of the console plugin as the Helm release name into a new namespace or an existing namespace as specified by the camel-dashboard-console parameter and providing the location of the image within the `plugin.image` parameter by using the following command:

```
helm upgrade -i camel-dashboard-console camel-tooling/camel-dashboard-console --version 0.2.0 --namespace camel-dashboard --set plugin.image=quay.io/camel-tooling/camel-dashboard-console:0.2.0
```

NOTE: the installation procedure is still in alpha phase. Verify the latest release and change the version (ie, `0.2.0`) from the previous script accordingly.


## Overview

Once installed, the **Camel Dashboard Console** features should be accessible in the OpenShift Console.

* The *Camel Applications* page displays the list of your deployed Camel Applications. It is available as a `Workloads` tab on the `admin` view and as a navigation tab on the `developer` view.
{{% imgproc oc-console-list-419 Resize "2520x1102" %}}
{{% /imgproc %}}

* The *Camel Application* page will show informations and metrics for the chose deployed Camel Application

    * informations from the Observability Services

{{% imgproc oc-console-details-419 Resize "2520x1102" %}}
{{% /imgproc %}}

   * Kubernetes native resources linked to the deployment, with some acces to logs, hawtio console, etc

{{% imgproc oc-console-resources-419 Resize "2520x1102" %}}
{{% /imgproc %}}

   * Prometheus metrics on resources utilization for the deployment

{{% imgproc oc-console-metrics-419 Resize "2520x1102" %}}
{{% /imgproc %}}
