---
title: "Enhanced Console and Operator Updates for Openshift 4.21"
linkTitle: "OpenShift 4.21.2 Update"
date: 2026-06-03
author: '[Gaëlle Fournier](https://github.com/gansheer)'
tags: ["release", "console", "operator", "openshift", "helm"]
icon: "sparkles"
images: ["/camel-dashboard/images/blog/camels_blog_4.jpg"]
draft: false
---

![Camel Dashboard monitoring interface](/camel-dashboard/images/blog/camels_blog_4.jpg)

We're happy to announce the new release of Camel Dashboard components, bringing important updates and improvements across the stack.

## What's New

### Camel Monitor Operator 0.2.1

This patch release of the Camel Monitor Operator includes stability improvements and bug fixes building on the solid foundation of the 0.2.0 release.

**Important**: The operator now uses the `CamelMonitor` custom resource (shortname `cmon`) instead of the legacy `CamelApp` resource introduced in version 0.2.0.

### Camel Dashboard Console 0.5.0

The latest console release includes compatibility with new `CamelMonitor` custom resource while keeping backward compatibility with `CamelApp` custom resource when monitoring Camel applications on OpenShift.

### Camel Dashboard OpenShift All 4.21.2

The umbrella Helm chart has been updated to bundle the latest versions of all components, providing a seamless installation experience for OpenShift 4.21.

## Installation

### Via OpenShift Catalog (Recommended)

1. Open the OpenShift Console
2. Navigate to **+Ecosystem** → **Software Catalog**
3. Search for "Camel Dashboard"
4. Select `Camel Dashboard on Openshift`
5. Configure and install

### Via Helm CLI

```bash
# Add the Helm repository
helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
helm repo update

# Install for OpenShift 4.21
helm install camel-dashboard-openshift-all \
  camel-dashboard/camel-dashboard-openshift-all \
  --version 4.21.2 \
  -n camel-dashboard \
  --create-namespace
```

## Upgrading from 4.21.1

**Important**: Helm does not automatically upgrade CRDs during chart upgrades. Version 4.21.2 introduces new CRDs from `camel-monitor-operator` v0.2.1. You must manually apply these CRDs before running `helm upgrade`:

```bash
# Update your Helm repository
helm repo update

# Apply the new CRDs manually (from camel-monitor-operator v0.2.1)
kubectl apply -f https://raw.githubusercontent.com/camel-tooling/camel-monitor-operator/v0.2.1/helm/camel-monitor/crds/camel-monitor-crds.yaml

# Now upgrade the chart
helm upgrade camel-dashboard-openshift-all \
  camel-dashboard/camel-dashboard-openshift-all \
  -n camel-dashboard
```

For detailed upgrade instructions, see the [Helm chart README](https://github.com/camel-tooling/camel-dashboard-openshift-all#upgrading).

## Component Versions

This release includes:

- **camel-monitor-operator**: 0.2.1
- **camel-dashboard-console**: 0.5.0
- **hawtio-online-console-plugin**: 0.7.0

## Resources

- [Installation Guide](/camel-dashboard/docs/installation-guide/)
- [Camel Dashboard Documentation](/camel-dashboard/docs/)
- [Helm Charts on Artifact Hub](https://artifacthub.io/packages/search?repo=camel-dashboard)
- [GitHub Repository](https://github.com/camel-tooling/camel-dashboard)

Thank you for using Camel Dashboard! If you have feedback or encounter any issues, please [open an issue on GitHub](https://github.com/camel-tooling/camel-dashboard-console/issues).
