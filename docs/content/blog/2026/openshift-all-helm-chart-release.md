---
title: "Simplifying Camel Dashboard Installation with the All-in-One Helm Chart"
linkTitle: "One-Step Installation"
date: 2026-02-08
author: '[Gaëlle Fournier](https://github.com/gansheer)'
tags: ["helm", "openshift", "installation"]
icon: "rocket"
images: ["/camel-dashboard/images/blog/camels_blog_2.jpg"]
---

![Camel Dashboard deployment made simple with the new all-in-one Helm chart for OpenShift](/camel-dashboard/images/blog/camels_blog_2.jpg)

We're excited to announce the release of **`camel-dashboard-openshift-all`**, a new umbrella Helm chart that dramatically simplifies the deployment of Camel Dashboard on OpenShift clusters.

## What's Included

Previously, deploying Camel Dashboard required installing multiple components separately:
- **Camel Dashboard Operator**: Manages Camel Dashboard instances
- **Camel Dashboard Console**: OpenShift Console plugin for monitoring
- **Hawtio Online Console Plugin**: Optional management console for Java applications

Now, this single Helm chart bundles all these components together with guaranteed version compatibility, eliminating the need to manage separate releases and coordinate their installation.

## Simple Installation

Getting started is now as simple as:

```bash
# Add the Helm repository
helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
helm repo update

# Install everything in one command
helm install camel-dashboard-openshift-all \
  camel-dashboard/camel-dashboard-openshift-all \
  --version 4.20.0 \
  -n camel-dashboard \
  --create-namespace
```

That's it! With a single command, you get a fully functional Camel Dashboard deployment with all components properly configured and compatible.

### Customization

You can still customize your installation with a values file:

```bash
helm install camel-dashboard-openshift-all \
  camel-dashboard/camel-dashboard-openshift-all \
  -n camel-dashboard \
  --create-namespace \
  -f my-values.yaml
```

For example, you might want to disable the optional Hawtio plugin or adjust resource limits.

For detailed installation instructions, see our [Installation Guide](/camel-dashboard/docs/installation-guide/).

## Implementation Details

The umbrella chart uses Helm's dependency mechanism to bundle the individual charts:
- The operator and console plugins are included as dependencies
- Hawtio is configured as an optional dependency
- Chart versioning follows the OpenShift release schema (4.19, 4.20, etc.)

This approach maintains the flexibility of individual charts while providing the simplicity of a single installation.

The `camel-dashboard-openshift-all` chart is available now from the official Camel Dashboard Helm repository.

### Requirements

- Helm 3.x
- OpenShift 4.19 or later

## Community Contribution

Special thanks to the users and contributors who identified this pain point and [helped design the solution](https://github.com/camel-tooling/camel-dashboard/issues/51).

If you have ideas for improving Camel Dashboard or any other Camel tooling, we encourage you to open an issue.

## What's Next?

We're continuing to improve the Camel Dashboard tooling based on your feedback. One of the most exciting features we're working on is enhancing the [HawtIO integration experience](https://github.com/camel-tooling/camel-dashboard-console/issues/122).


## Resources

- [Helm Charts](https://artifacthub.io/packages/search?repo=camel-dashboard)
- [Camel Dashboard Documentation](/camel-dashboard/docs/)
- [Installation Guide](/camel-dashboard/docs/installation-guide/)

Happy monitoring with Camel Dashboard!
