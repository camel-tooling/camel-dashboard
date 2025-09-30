---
title: "Deployment"
linkTitle: "Deployment"
weight: 40
---

This guide covers deploying Apache Camel applications to Kubernetes and OpenShift platforms.

**📚 For more details, see:**
- [Camel JBang Kubernetes Guide](https://camel.apache.org/manual/camel-jbang-kubernetes.html)
- [Eclipse JKube Documentation](https://github.com/eclipse/jkube)
- [Quarkus Kubernetes Guide](https://quarkus.io/guides/deploying-to-kubernetes)

**⚠️ Requirements:**
- Kubernetes or OpenShift
- Container registry access
- Maven 3.8+
- kubectl or oc CLI tools

**ℹ️ Common Deployment Strategies:**

- **Camel JBang** - Simplest approach with one-command deployment
- **Maven Plugins** - Eclipse JKube, Quarkus Kubernetes

## Camel JBang Deployment

The simplest approach for deploying Camel applications to Kubernetes. It works for any of the Camel runtimes.

### Setup

```bash
# Install Kubernetes plugin
camel plugin add kubernetes
```

### Direct Deployment

```bash
# Deploy route directly to Kubernetes
camel kubernetes run MyRoute.java --image-registry=kind

# Deploy with specific runtime
camel kubernetes run MyRoute.java --runtime=quarkus --image-registry=docker.io/myuser

# Deploy to OpenShift
camel kubernetes run MyRoute.java --cluster-type=openshift
```

### Development Mode

```bash
# Deploy with auto-reload for development
camel kubernetes run MyRoute.java --dev --image-registry=kind
```

### Export and Customize

```bash
# Generate Kubernetes project
camel kubernetes export MyRoute.java --dir my-project --runtime=quarkus

# Build and deploy the generated project
cd my-project
mvn package -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true
kubectl apply -f target/kubernetes/kubernetes.yml
```

**🔗 Examples:**
- [Camel JBang Kubernetes Examples](https://github.com/tdiesler/camel-cloud-examples/)


### Discovery configuration for Camel Dashboard

To configure Camel application before deployment for Camel Dashboard add the following label to your export or run command:
```bash
$ [...] --label="camel.apache.org/app=my-route"
```

If your Camel version in older than 4.12, you need to configure the business port:
```bash
$ [...] --annotation="camel.apache.org/observability-services-port=8080"
```

You can add some additional non-optional configurations:
```bash
# Configure custom SLI Exchange error and warning percentage
$ [...] --annotation="camel.apache.org/sli-exchange-error-percentage=1" --annotation="camel.apache.org/sli-exchange-warning-percentage=5"
```

## Maven Plugin Deployments for Kubernetes

### Quarkus Applications

Quarkus provides the most integrated Kubernetes experience with automatic manifest generation.

**🔗 Examples:**

#### Adding Kubernetes Support to Existing Project

For an existing Camel Quarkus project, add the Kubernetes extensions to your `pom.xml`:

```xml
<dependencies>
    <!-- Your existing Camel Quarkus dependencies -->
    <!-- ... -->

    <!-- Add Kubernetes integration -->
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-kubernetes</artifactId>
    </dependency>
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-container-image-jib</artifactId>
    </dependency>
</dependencies>
```

**📚 For more configuration options, see:**
- [Camel Quarkus Observability Example](https://github.com/apache/camel-quarkus-examples/tree/main/observability/)
* [Quarkus Kubernetes Extension](https://quarkus.io/guides/deploying-to-kubernetes#kubernetes)


### Configuration for Camel Dashboard

To configure Camel application before deployment for Camel Dashboard add the following label to your properties in `application.properties`:
```properties
quarkus.kubernetes.labels."camel.apache.org/app"=my-camel-app
```

If your Camel version in older than 4.12, you need to configure the business port:
```properties
quarkus.kubernetes.annotations."camel.apache.org/observability-services-port"=8080
```

You can add some additional non-optional configurations:
```properties
// Configure custom SLI Exchange error and warning percentage
quarkus.kubernetes.annotations."camel.apache.org/sli-exchange-error-percentage"=1
quarkus.kubernetes.annotations."camel.apache.org/sli-exchange-warning-percentage"=5
```

#### Build and Deploy

```bash
# Build container image and generate manifests
mvn clean package -Dquarkus.container-image.build=true

# Build, push and deploy in one command
mvn clean package -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true -Dquarkus.kubernetes.deploy=true

# Or deploy manually
kubectl apply -f target/kubernetes/kubernetes.yml
```

#### Native Image Deployment

```bash
# Build native image for faster startup and smaller memory footprint
mvn clean package -Dnative -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true
```

### Spring Boot Applications

#### Eclipse JKube Plugin

**Maven Configuration:**
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>kubernetes-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <executions>
        <execution>
            <goals>
                <goal>resource</goal>
                <goal>build</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

**📚 For more configuration options, see:**
* [Apache Camel Spring Boot Strimzi Example](https://github.com/apache/camel-spring-boot-examples/tree/main/strimzi)
* [Kubernetes Maven Plugin Documentations](https://eclipse.dev/jkube/docs/kubernetes-maven-plugin/)

**Build and Deploy:**
```bash
# Build Docker image
mvn k8s:build

# Generate Kubernetes manifests
mvn k8s:resource

# Deploy to Kubernetes
mvn k8s:apply

# All in one command
mvn clean package k8s:build k8s:resource k8s:apply
```

### Configuration for Camel Dashboard

If you want to configure Camel application before deployment for Camel Dashboard add the following label to your properties in `kubernetes-maven-plugin` configuration:

```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>kubernetes-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <labels>
                <deployment>
                    <property>
                        <name>camel.apache.org/app</name>
                        <value>my-camel-app</value>
                    </property>
                </deployment>
            </labels>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```

If your Camel version in older than 4.12, you need to configure the business port:
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>kubernetes-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <annotations>
                <deployment>
                    <property>
                        <name>camel.apache.org/observability-services-port</name>
                        <value>8080</value>
                    </property>
                </deployment>
            </annotations>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```

You can add some additional non-optional configurations:
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>kubernetes-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <annotations>
                <deployment>
                    <!-- Configure custom SLI Exchange error and warning percentage -->
                    <property>
                        <name>camel.apache.org/sli-exchange-error-percentage</name>
                        <value>1</value>
                    </property>
                    <property>
                        <name>camel.apache.org/sli-exchange-warning-percentage</name>
                        <value>5</value>
                    </property>
                </deployment>
            </annotations>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```


## Maven Plugin Deployments for Openshift

### Quarkus Applications

For an existing Camel Quarkus project, add the Openshift extension to your `pom.xml`:

```xml
<dependencies>
    <!-- Your existing Camel Quarkus dependencies -->
    <!-- ... -->

    <!-- Add Openshift integration -->
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-openshift</artifactId>
    </dependency>
</dependencies>
```


**📚 For more configuration options, see:**
- [Camel Quarkus Observability Example](https://github.com/apache/camel-quarkus-examples/tree/main/observability/)
* [Quarkus Openshift Extension](https://quarkus.io/guides/deploying-to-openshift)

#### Build and Deploy

```bash
# Build container image and generate OpenShift manifests
mvn clean package -Dquarkus.container-image.build=true

# Build, push and deploy to OpenShift in one command
mvn clean package -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true -Dquarkus.openshift.deploy=true

# Or deploy manually after build
oc apply -f target/kubernetes/openshift.yml
```

#### Native Image Deployment

Native images provide faster startup times and lower memory consumption, ideal for OpenShift environments:

```bash
# Build native image for OpenShift
mvn clean package -Dnative -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true -Dquarkus.openshift.deploy=true

# Build native image locally (requires GraalVM)
mvn clean package -Dnative -Dquarkus.native.container-build=true
```

**Configuration for native builds:**
```properties
# application.properties
quarkus.native.container-build=true
quarkus.container-image.builder=jib
quarkus.openshift.deploy=true
```


### Configuration for Camel Dashboard

To configure Camel application before deployment for Camel Dashboard add the following label to your properties in `application.properties`:
```properties
quarkus.openshift.labels."camel.apache.org/app"=my-camel-app
```

If your Camel version in older than 4.12, you need to configure the business port:
```properties
quarkus.openshift.annotations."camel.apache.org/observability-services-port"=8080
```

You can add some additional non-optional configurations:
```properties
// Configure custom SLI Exchange error and warning percentage
quarkus.openshift.annotations."camel.apache.org/sli-exchange-error-percentage"=1
quarkus.openshift.annotations."camel.apache.org/sli-exchange-warning-percentage"=5
`

### Spring Boot Applications

#### Eclipse JKube Plugin

**Maven Configuration:**
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>openshift-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <executions>
        <execution>
            <goals>
                <goal>resource</goal>
                <goal>build</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

**📚 For more configuration options, see:**
* [Apache Camel Best Practice Example](https://github.com/jboss-fuse/apache-camel-on-ocp-best-practices/tree/main/examples/ocp/http-ssl)
* [Apache Camel Spring Boot Saga Example](https://github.com/apache/camel-spring-boot-examples/tree/main/saga)
* [Openshift Maven Plugin Documentations](https://eclipse.dev/jkube/docs/openshift-maven-plugin/)

**Commands:**
```bash
# Build using S2I
mvn oc:build

# Generate OpenShift manifests
mvn oc:resource

# Deploy to OpenShift
mvn oc:apply

# All in one
mvn clean package oc:build oc:resource oc:apply
```


### Configuration for Camel Dashboard

If you want to configure Camel application before deployment for Camel Dashboard add the following label to your properties in `openshift-maven-plugin` configuration:

```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>openshift-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <labels>
                <deployment>
                    <property>
                        <name>camel.apache.org/app</name>
                        <value>my-camel-app</value>
                    </property>
                </deployment>
            </labels>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```

If your Camel version in older than 4.12, you need to configure the business port:
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>openshift-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <annotations>
                <deployment>
                    <property>
                        <name>camel.apache.org/observability-services-port</name>
                        <value>8080</value>
                    </property>
                </deployment>
            </annotations>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```

You can add some additional non-optional configurations:
```xml
<plugin>
    <groupId>org.eclipse.jkube</groupId>
    <artifactId>openshift-maven-plugin</artifactId>
    <version>${jkube-maven-plugin-version}</version>
    <configuration>
        <!-- ... -->
        <resources>
            <annotations>
                <deployment>
                    <!-- Configure custom SLI Exchange error and warning percentage -->
                    <property>
                        <name>camel.apache.org/sli-exchange-error-percentage</name>
                        <value>1</value>
                    </property>
                    <property>
                        <name>camel.apache.org/sli-exchange-warning-percentage</name>
                        <value>5</value>
                    </property>
                </deployment>
            </annotations>
        </resources>
        <!-- ... -->
    </configuration>
    <!-- ... -->
</plugin>
```