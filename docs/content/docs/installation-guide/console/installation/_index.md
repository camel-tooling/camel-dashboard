---
title: "Installation"
weight: 10
---


A [Helm](https://helm.sh) chart is available to deploy the console plugin to an OpenShift environment.

The following Helm parameters are required:

`plugin.image:` The location of the image containing the console plugin that was previously pushed

Additional parameters can be specified if desired. Consult the chart values file for the full set of supported parameters.

### Installing the Helm Chart

First, add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/) (you might have already done it if you installed the [Camel Dashboard Operator](/camel-dashboard/docs/operator)):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

Install the chart using the name of the console plugin as the Helm release name into a new namespace or an existing namespace as specified by the camel-dashboard-console parameter and providing the location of the image within the `plugin.image` parameter by using the following command:

```bash
helm upgrade -i camel-dashboard-console camel-tooling/camel-dashboard-console --version 0.2.0 --namespace camel-dashboard --set plugin.image=quay.io/camel-tooling/camel-dashboard-console:0.2.0
```

> NOTE: the installation procedure is still in alpha phase. Verify the latest release and change the version (ie, `0.2.0`) from the previous script accordingly.
