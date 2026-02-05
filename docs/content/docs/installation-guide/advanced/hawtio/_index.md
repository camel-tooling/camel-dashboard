---
title: "HawtIO Console Plugin"
weight: 50
resources:
- src: "**oc-console-hawtio-link-420*.png"
  params:
    byline: "HawtIO link"
- src: "**oc-hawtio-online-420*.png"
  params:
    byline: "HawtIO Console Plugin for Openshift"
---

[HawtIO](https://hawt.io/) is a powerful pluggable Web management console that provides its build-in plugin that supports Apache Camel.

[HawtIO Console Plugin for Openshift](https://github.com/hawtio/hawtio-online-console-plugin?tab=readme-ov-file#hawtio-online-openshift-console-plugin) is a dynamic plugin that integrates the Hawtio Online console into the OpenShift console.

> WARNING: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `hawtio-online-console-plugin.`

## Installation

A [Helm](https://helm.sh) chart is available to deploy the HawtIO Console Plugin to an OpenShift environment.

See the HawtIO Console Plugin [installation documentation](https://github.com/hawtio/hawtio-charts?tab=readme-ov-file#hawtio-console-plugin-for-openshift).

## Overview

By default the HawtIO Console Plugin for Openshift offers the [features](https://github.com/hawtio/hawtio-online-console-plugin?tab=readme-ov-file#hawtio-online-openshift-console-plugin) from the HawtIO Online console into the Openshift.

It is directly accessible from the **Camel Dashboard Console** for any Camel Application deployment [HawtIO enabled](https://github.com/hawtio/hawtio-online?tab=readme-ov-file#hawtio-enabled-application-examples):

{{% imgproc oc-console-hawtio-link-420 Resize "1935x1001" %}}
{{% /imgproc %}}

{{% imgproc oc-hawtio-online-420 Resize "1935x1001" %}}
{{% /imgproc %}}