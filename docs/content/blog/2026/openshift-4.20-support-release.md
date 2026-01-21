---
title: "Camel Dashboard Now Compatible with OpenShift 4.20"
linkTitle: "OpenShift 4.20 Support"
date: 2026-01-16
author: '[Gaëlle Fournier](https://github.com/gansheer)'
tags: ["release", "console", "hawtio", "openshift"]
icon: "rocket"
images: ["/camel-dashboard/images/blog/camels_blog_1.jpg"]
aliases:
    /blog/2025/openshift-4.20-support-release/
---

![Camel Dashboard monitoring interface showing real-time metrics for Apache Camel applications running on OpenShift 4.20 clusters](/camel-dashboard/images/blog/camels_blog_1.jpg)


We're pleased to announce that **Camel Dashboard is now fully compatible with OpenShift 4.20** with new releases of both console plugins!

## OpenShift 4.20 Compatibility

Both **Camel Dashboard Console 0.3.1** and **Hawtio Online Console Plugin 0.6.0** bring full support for the latest OpenShift 4.20 release, ensuring seamless integration with the newest features and improvements of the OpenShift platform.

### Camel Dashboard Console 0.3.1

This release includes several enhancements:

- ✨ **Refreshed visual design** for a better user experience
- 📊 **New exchange message metrics cards** to monitor your Camel routes performance
- 🔧 **Enhanced plugin management** with Hawtio plugin detection
- ⚡ **Modernized metrics collection** using the console dynamic plugin SDK

### Hawtio Online Console Plugin 0.6.0

This release brings OpenShift 4.20 compatibility to Hawtio Online, allowing you to manage and monitor your Java applications directly from the OpenShift console.

### Overview

{{< youtube HNHX1qXM7dA >}}

## Get the Releases

Container images are available at:

**Camel Dashboard Console:**
```
quay.io/camel-tooling/camel-dashboard-console:0.3.1
```

**Hawtio Online Console Plugin:**
```
quay.io/hawtio/online-console-plugin:0.6.0
```

### Installation

Both console plugins can be deployed using their respective Helm charts. For detailed installation instructions, see our [Installation Guide](/camel-dashboard/docs/installation-guide/).

For full release notes and all the technical details:
- [Camel Dashboard Console v0.3.1 release on GitHub](https://github.com/camel-tooling/camel-dashboard-console/releases/tag/v0.3.1)
- [Hawtio Online Console Plugin v0.6.0 release on GitHub](https://github.com/hawtio/online-console-plugin/releases/tag/v0.6.0)

## What's Next

We're working on simplifying the installation experience with an umbrella Helm chart that will allow you to deploy all Camel Dashboard components with a single command. Follow the progress on [GitHub issue #51](https://github.com/camel-tooling/camel-dashboard/issues/51).

## Resources

### Camel Dashboard Console
- [Installation Guide](/camel-dashboard/docs/installation-guide/)
- [GitHub Repository](https://github.com/camel-tooling/camel-dashboard-console)
- [Documentation](/camel-dashboard/docs/)

### Hawtio Online Console Plugin
- [GitHub Repository](https://github.com/hawtio/online-console-plugin)
- [Hawtio Documentation](https://hawt.io/)
