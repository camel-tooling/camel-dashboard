---
title: "Observability Services"
linkTitle: "Observability Services"
weight: 30
---


Camel Dashboard is designed to consume the services exposed by [Camel Observability Services component](https://camel.apache.org/components/next/others/observability-services.html).


**📚 For more details, see:**
- [Camel Observability Services introduction](https://camel.apache.org/blog/2025/03/camel-observability/)

**⚠️ Requirements:**
- Apache Camel 4.9 or higher

**ℹ️ Common Observability Endpoints:**

All runtimes expose these standard endpoints (default port 9876):
- `/observe/health` - Startup probe
- `/observe/health/live` - Liveness probe
- `/observe/health/ready` - Readiness probe
- `/observe/metrics` - Prometheus metrics

> ⚠️ **Important:** The observability endpoints are exposed in the management port (default `9876`) since Camel 4.12. For previous versions it used the business port (default `8080`).

## Apache Camel with JBang

You simply either run with --observe option (use --metrics in older Camel versions):

```bash
camel run MyRoute.java --observe
```

Alternatively, you can [enable](https://camel.apache.org/manual/camel-jbang.html#_observability_with_metrics) and have more control of the configuration in the application.properties.


## Apache Camel Core Runtime

All you need to do is to add the [camel-observability-services](https://camel.apache.org/components/next/others/observability-services.html) dependency:

```xml
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-observability-services</artifactId>
</dependency>
```

This provides the foundational observability capabilities optimized for cloud and containerized environments.

## Apache Camel with Quarkus Runtime

Add the [camel-quarkus-observability-services](https://camel.apache.org/camel-quarkus/next/reference/extensions/observability-services.html) extension to your existing project. This provides a complete observability solution with opinionated configuration optimized for cloud environments.

```xml
<dependency>
    <groupId>org.apache.camel.quarkus</groupId>
    <artifactId>camel-quarkus-observability-services</artifactId>
</dependency>
```

**🔗 GitHub Examples:**
- [Camel Quarkus Observability Services Example](https://github.com/apache/camel-quarkus-examples/tree/main/observability)

## Apache Camel with Spring Boot

The `camel-observability-services-starter` is specifically designed for Spring Boot integration and provides the same observability endpoints with proper Spring Boot auto-configuration. Unlike the core `camel-observability-services` dependency, the starter offers full Spring Boot integration without configuration limitations.

```xml
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-observability-services-starter</artifactId>
</dependency>
```

**🔗 GitHub Examples:**
- [Camel Spring Boot Observability Services Example](https://github.com/apache/camel-spring-boot-examples/tree/main/observability-services)


## Testing and Verification

After adding observability services, verify the endpoints are working:

```bash
# Check health endpoints
curl http://localhost:9876/observe/health
curl http://localhost:9876/observe/health/live
curl http://localhost:9876/observe/health/ready

# Check metrics
curl http://localhost:9876/observe/metrics
```

For local OpenTelemetry testing:
```bash
docker run -p 4318:4318 otel/opentelemetry-collector-contrib:0.113.0
```