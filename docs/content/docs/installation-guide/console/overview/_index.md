---
title: "Overview"
weight: 20
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
