---
title: "Camel Monitor Operator"
linkTitle: "Camel Monitor Operator"
weight: 30
aliases:
  - /docs/installation-guide/operator/configuration/
---

The **Camel Monitor Operator** is a project created to simplify the management of any Camel application on a Kubernetes cluster. The tool is in charge to **monitor any Camel application** and provide a set of basic information, useful to learn how your fleet of Camel (a caravan!?) is behaving.

The project is designed to be as simple and low resource consumption as possible. It only collects the most important Camel application KPI in order to quickly identify what's going on across your Camel applications.

> NOTE: If you installed the camel-dashboard-openshift-all helm chart you need to prefix any configuration in helm chart values by `camel-monitor-operator.`

## Installation

We offer different installation methodologies: Helm, Kustomize (via `kubectl`) and OLM.

### Helm

You can use [Helm](https://helm.sh) to install the operator resources. You can install it in any namespace (we conventionally use `camel-dashboard` namespace, which, has to be created previously). The default configuration is for a cluster scoped operator (use `--set operator.global="false"` for a namespace scoped operator).


* Add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/):
```bash
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

* Confirm the addition of the repository:
```bash
$ helm repo list

NAME    URL
camel-dashboard	https://camel-tooling.github.io/camel-dashboard/charts/
```

* Install the *operator* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:
```bash
$ helm install camel-monitor-operator camel-dashboard/camel-monitor-operator -n camel-dashboard
```

You can check if the operator is running:

```bash
$ kubectl get pods -n camel-dashboard
NAME                                        READY   STATUS    RESTARTS   AGE
camel-monitor-operator-7c6bcf5576-fwn7s   1/1     Running   0          4m18s
```

### Kustomize

[Kustomize](https://kustomize.io/) provides a declarative approach to the configuration customization of a Camel Monitor Operator installation. Kustomize works either with a standalone executable or as a built-in to `kubectl`. The `/install` directory provides a series of base and overlays configuration that you can use. You can create your own overlays or customize the one available in the repository to accommodate your need.

```bash
$ kubectl create ns camel-monitor
$ kubectl apply -k github.com/camel-tooling/camel-monitor-operator/install/overlays/all-namespaces?ref=v0.2.1 --server-side
```

You can specify as ref parameter the version you’re willing to install (ie, v0.2.1). The command above will install a global operator (watching all namespaces) in the `camel-monitor` namespace. This is the suggested configuration in order to manage `CamelMonitors` in all namespaces.

### OLM

Camel Monitor is also available in Operator Hub. You will need the OLM framework to be properly installed in your cluster.

```bash
$ kubectl create -f https://operatorhub.io/install/camel-monitor-operator.yaml
```

You can edit the Subscription custom resource, setting the channel you want to use. We provide an installation channel for `latest` and each major version we’re releasing (ie, `stable-v0`). This will simplify the upgrade process if you choose to perform an automatic upgrade.

> NOTE: some Kubernetes clusters such as Openshift may let you to perform the same operation from a GUI as well. Refer to the cluster instruction to learn how to perform such action from user interface.

> NOTE: when installed via OLM in **global mode** on OpenShift, the operator automatically deploys the [Camel Dashboard Console](/camel-dashboard/docs/installation-guide/advanced/console/) plugin — no separate installation is required. See the [console documentation](/camel-dashboard/docs/installation-guide/advanced/console/#automatic-deployment-via-olm) for details.

### Installation topologies

When you decide to install the operator, you can decide to install the following topology:

* Global operator: a single global operator watching all namespaces.
* Own namespace operator: a namespaces operator watching its own namespace only.
* Single namespace operator: an operator installed in a namespace and watching another namespace.
* Multi namespace operator: an operator installed in a namespace and watching multiple namespaces.

The namespace(s) to watch is configured via `WATCH_NAMESPACE` variable in the operator `Deployment` resource. You can provide an empty value (watch all namespaces), a single value (watch either the own namespace or any other namespace) or a comma separated value (watching as many namespaces as provided).

It's important to notice that when running the single or multiple namespace operator, you will need to provide the RBACs which are expected by the operator to run properly. For such a configuration you can take as a reference the `Kustomize` examples available in `/install/overlays/single-namespace/` and `/install/overlays/multi-namespace/`. The last topology is probably the most secure as it will avoid the operator to access to any resource outside those namespaces for which you've provided the proper security rules.
