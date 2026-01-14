---
title: "Camel Dashboard Console"
weight: 40
---

This operator can work standalone and you can use the data exposed in the `CamelApp` custom resource accordingly. However it has a great fit with the [Camel Dashboard Console](https://github.com/camel-tooling/camel-dashboard-console?tab=readme-ov-file#deployment-to-openshift), which is a visual representation of the services exposed by the operator.

## Camel Dashboard Console dependencies matrix

The Camel Dashboard Console is a plugin extension of OpenShift Console exposing the data from the Camel Dashboard Operator.

Below you can find the compatibility list for its dependencies:

| Camel Dashboard Console | Openshift          | Camel Dashboard Operator |
| ----------------------- | ------------------ | ------------------------ |
| next (0.3.2)            | Openshift 4.20+    | 0.1.0                    |
| 0.3.1                   | Openshift 4.20+    | 0.1.0                    |
| 0.2.2                   | Openshift 4.19     | 0.1.0                    |
| 0.1.0                   | Openshift 4.18     | 0.0.1                    |

NOTE: the old version 0.1.0 uses the old `App` custom resource.


