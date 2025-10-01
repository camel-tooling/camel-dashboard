---
title: "Overview"
weight: 20
resources:
- src: "**oc-console-list-419*.png"
  params:
    byline: "Camel Applications"
- src: "**oc-console-details-419*.png"
  params:
    byline: "Camel Application > Details"
- src: "**oc-console-resources-419*.png"
  params:
    byline: "Camel Application > Resources"
- src: "**oc-console-metrics-419*.png"
  params:
    byline: "Camel Application > Metrics"
---

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
