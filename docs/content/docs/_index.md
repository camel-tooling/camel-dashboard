---
title: "Documentation"
linkTitle: "Documentation"
weight: 20
---

{{% pageinfo %}}
This is the documentation for the Camel Dashboard Operator.
{{% /pageinfo %}}

The **Camel Dashboard Operator** is a project created to simplify the management of any Camel application on a Kubernetes cluster. The tool is in charge to **monitor any Camel application** and provide a set of basic information, useful to learn how your fleet of Camel (a caravan!?) is behaving.

The project is designed to be as simple and low resource consumption as possible. It only collects the most important Camel application KPI in order to quickly identify what's going on across your Camel applications.

NOTE: as the project is still in an experimental phase, the metrics collected can be changed at each development iteration.