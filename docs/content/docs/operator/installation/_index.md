---
title: "How to install the operator"
weight: 10
---

You can use [Helm](https://helm.sh) to install the operator resources. You can install it in any namespace (we conventionally use `camel-dashboard` namespace, which, has to be created previously). The default configuration is for a cluster scoped operator (use `--set operator.global="false"` for a namespace scoped operator).


* Add the chart repository to the local helm [configuration](https://helm.sh/docs/helm/helm_repo_add/):
```
$ helm repo add camel-dashboard https://camel-tooling.github.io/camel-dashboard/charts
```

* Confirm the addition of the repository:
```
$ helm repo list

NAME    URL                                   
camel-tooling	https://camel-tooling.github.io/camel-dashboard/charts/
```

* Install the *operator* using the helm [install](https://helm.sh/docs/helm/helm_install/) command:
```
$ helm install camel-dashboard-operator camel-tooling/camel-dashboard-operator --version 0.1.0 -n camel-dashboard
```

> NOTE: The installation procedure is still in alpha phase. Verify the latest release and change the version (ie, `0.1.0`) from the previous script accordingly.

You can check if the operator is running:

```
kubectl get pods -n camel-dashboard
NAME                                        READY   STATUS    RESTARTS   AGE
camel-dashboard-operator-7c6bcf5576-fwn7s   1/1     Running   0          4m18s
```