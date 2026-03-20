---
title: "Camel Dashboard Now Compatible with OpenShift 4.21"
linkTitle: "OpenShift 4.21 Support"
date: 2026-03-20
author: '[Gaëlle Fournier](https://github.com/gansheer)'
tags: ["release", "console", "hawtio", "openshift", "helm"]
icon: "rocket"
images: ["/camel-dashboard/images/blog/camels_blog_3.jpg"]
draft: false
---

![Camel Dashboard monitoring interface showing real-time metrics for Apache Camel applications running on OpenShift 4.21 clusters](/camel-dashboard/images/blog/camels_blog_3.jpg)

We're excited to announce that **Camel Dashboard is now fully compatible with OpenShift 4.21**, bringing enhanced integration capabilities and a streamlined installation experience.

## OpenShift 4.21 Compatibility

The latest releases of Camel Dashboard components bring full support for OpenShift 4.21, ensuring seamless integration with the newest features and improvements of the OpenShift platform. This compatibility update ensures that you can take advantage of the latest OpenShift capabilities while monitoring and managing your Apache Camel applications.

## New Hawtio Tab Integration

One of the most exciting features in this release is the **integrated Hawtio tab** directly within the CamelApp page. This provides real-time access to Camel route monitoring, JMX metrics, and thread analysis—all without leaving the Camel Openshift Console. This enhancement makes it effortless to dive deep into your application's runtime behavior when you need detailed diagnostics.

TODO: add screenshot 

## Simplified Discovery with OpenShift Ecosystem Catalog

Installing Camel Dashboard is now easier than ever. The **`camel-dashboard-openshift-all` Helm chart is now available directly in OpenShift's ecosystem catalog**.

### What This Means for You

Previously, users had to search external documentation to find the Camel Dashboard Helm chart. Now, you can discover and install Camel Dashboard directly from the OpenShift Developer Catalog.

TODO: add image

This integration into OpenShift's official ecosystem makes Camel Dashboard a first-class citizen in the OpenShift platform, improving discoverability and reducing installation friction.

### Overview

{{< youtube TODO-videotag >}}

## Installation

### Via OpenShift Catalog (Recommended)

1. Open the OpenShift Console
2. Navigate to **+Add** → **Helm Chart** from the Developer perspective
3. Search for "Camel Dashboard"
4. Select `camel-dashboard-openshift-all`
5. Configure and install

### Via Helm CLI

```bash
# Add the Helm repository
helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
helm repo update

# Install for OpenShift 4.21
helm install camel-dashboard-openshift-all \
  camel-dashboard/camel-dashboard-openshift-all \
  --version 4.21.0 \
  -n camel-dashboard \
  --create-namespace
```

For detailed installation instructions and customization options, see our [Installation Guide](/camel-dashboard/docs/installation-guide/).


## What's Next

We're continuing to enhance the Camel Dashboard experience based on your feedback. We're exploring leveraging Micrometer Prometheus technology for enhanced metrics.

If you have ideas for improving Camel Dashboard, we encourage you to [open an issue on GitHub](https://github.com/camel-tooling/camel-dashboard-console/issues).

## Resources

- [Installation Guide](/camel-dashboard/docs/installation-guide/)
- [Camel Dashboard Documentation](/camel-dashboard/docs/)
- [Helm Charts on Artifact Hub](https://artifacthub.io/packages/search?repo=camel-dashboard)
- [Hawtio Documentation](https://hawt.io/)

Happy monitoring with Camel Dashboard on OpenShift 4.21!
