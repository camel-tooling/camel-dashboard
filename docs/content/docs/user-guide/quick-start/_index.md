---
title: "Quick Start"
linkTitle: "Quick Start"
weight: 10
---

## Run a new Camel application

Let's run some sample Camel application. We have prepared a few available to run some quick demo:

* A Camel main application available at `docker.io/squakez/db-app-main:4.20.0`
* A Camel Quarkus application available at `docker.io/squakez/db-app-quarkus:4.20.0`
* A Camel Spring Boot application available at `docker.io/squakez/db-app-sb:4.20.0`

These applications were created, exported and "containerized" via Camel JBang, which includes by default the aforementioned `camel-observability-services` dependency. Source code available in https://github.com/camel-tooling/camel-dashboard-samples.

Let's run them in a Kubernetes cluster (it also works in a local cluster such as `Minikube`):

```bash
kubectl create deployment camel-app-quarkus --image=docker.io/squakez/db-app-quarkus:4.20.0
```

The application should start, but, since there is no label for the operator, this one cannot discover it.

> NOTE: ideally your pipeline process should be the one in charge to include this and any other label to the applications.

Let's include the label via CLI:

```bash
kubectl label deployment camel-app-quarkus camel.apache.org/monitor=camel-app-quarkus
```

> NOTE: you can test it straight away with any of your existing Camel application by adding the label as well.

The application is immediately imported by the operator. Its metrics are also scraped and available to be monitored:

```bash
kubectl get camelmonitors
NAME                INFO                        PHASE     REPLICAS   HEALTHY   MONITORED   MEMORY PRESSURE   CPU PRESSURE   EXCHANGE SLI   LAST EXCHANGE
camel-app-quarkus   Quarkus - 3.36.0 (4.20.0)   Running   1          True      True        False             False          Error          51s
```

> NOTE: more information are available inspecting the custom resource (i.e. via `-o yaml`).
