---
title: "Camel Project"
linkTitle: "Camel Project"
weight: 20
---

You need an Camel Application to monitor. If you don't have one yet, this guide briefly covers how to create an Apache Camel Project.

**🎯 Quick Decision Matrix:**
- **Camel JBang**: Choose for prototyping, scripting, learning, and quick testing
- **Camel Core**: Choose when you need full control and traditional Java application architecture
- **Camel Quarkus**: Choose for cloud-native, microservices, fast startup, low memory footprint
- **Camel Spring Boot**: Choose for enterprise applications with existing Spring ecosystem

## Apache Camel with JBang

### Quick Start
Install JBang and Camel CLI:
```bash
# Install JBang (Linux/macOS)
curl -Ls https://sh.jbang.dev | bash -s - app install --fresh --force jbang

# Install Camel CLI
jbang app install camel@apache/camel

# Create a simple route
camel init MyRoute.java
```

This gives you a simple Route:
```java
import org.apache.camel.builder.RouteBuilder;

public class MyRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        from("timer:java?period=1000")
            .setBody()
                .simple("Hello Camel from ${routeId}")
            .log("${body}");
    }
}
```

### Running
```bash
# Use Camel CLI
camel run MyRoute.java
```

Camel JBang is primary intended to be Camel standalone only but since Camel 4.6 it offers [limited support for running with Spring Boot or Quarkus](https://camel.apache.org/manual/camel-jbang.html#_running_with_spring_boot_or_quarkus).

Don't hesitate to run `camel --help` as CamelJBang supports multiple commands.


**📚 For complete setup and configuration details, see:**
- [Camel JBang Documentation](https://camel.apache.org/manual/camel-jbang.html)
- [JBang Installation Guide](https://www.jbang.dev/download/)


**🔗 GitHub Examples:**
- [Camel JBang Examples](https://github.com/apache/camel-jbang-examples)


## Apache Camel Core Runtime

### Quick Start
Create a new Camel project using Maven archetype:
```bash
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-camel-app \
  -DarchetypeGroupId=org.apache.camel.archetypes \
  -DarchetypeArtifactId=camel-archetype-java \
  -DarchetypeVersion=4.4.0 \
  -DinteractiveMode=false
```

### Simple Example Route
```java
// src/main/java/com/example/MyRoute.java
import org.apache.camel.builder.RouteBuilder;

public class MyRoute extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        from("timer:hello?period=5000")
            .setBody(constant("Hello from Camel Core!"))
            .log("${body}");
    }
}
```

**📚 For complete setup and configuration details, see:**
- [Getting Started with Camel](https://camel.apache.org/camel-core/getting-started/)
- [Camel Maven Archetypes](https://camel.apache.org/manual/camel-maven-archetypes.html)
- [Camel Components](https://camel.apache.org/components/next/index.html)

**🔗 GitHub Examples:**
- [Camel Core Examples](https://github.com/apache/camel-examples)

## Apache Camel with Quarkus Runtime

### Quick Start
Create a new Camel-Quarkus project:
```bash
# Using Quarkus CLI
quarkus create app com.example:my-camel-quarkus-app \
  --extension='camel-quarkus-core,camel-quarkus-timer,camel-quarkus-log'

# Or using Maven
mvn io.quarkus.platform:quarkus-maven-plugin:3.8.0:create \
  -DprojectGroupId=com.example \
  -DprojectArtifactId=my-camel-quarkus-app \
  -Dextensions="camel-quarkus-core,camel-quarkus-timer,camel-quarkus-log"
```

### Simple Example Route
```java
// src/main/java/com/example/MyQuarkusRoute.java
import org.apache.camel.builder.RouteBuilder;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class MyQuarkusRoute extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        from("timer:hello?period=5000")
            .setBody(constant("Hello from Camel Quarkus!"))
            .log("${body}");
    }
}
```

### Running
```bash
mvn quarkus:dev  # Development mode with hot reload
```

**📚 For complete setup and configuration details, see:**
- [Camel Quarkus Getting Started](https://camel.apache.org/camel-quarkus/next/user-guide/first-steps.html)
- [Quarkus Initializr with Camel](https://code.quarkus.io/) (search for "Camel")
- [Camel Quarkus Extensions](https://camel.apache.org/camel-quarkus/latest/reference/extensions/index.html)

**🔗 GitHub Examples:**
- [Camel Quarkus Examples](https://camel.apache.org/camel-quarkus/next/user-guide/examples.html)

## Apache Camel with Spring Boot

### Quick Start
Create a new Camel Spring Boot project:
```bash
# Using Maven archetype
mvn archetype:generate \
  -DgroupId=com.example \
  -DartifactId=my-camel-spring-boot-app \
  -DarchetypeGroupId=org.apache.camel.archetypes \
  -DarchetypeArtifactId=camel-archetype-spring-boot \
  -DarchetypeVersion=4.4.0 \
  -DinteractiveMode=false
```

### Simple Example Route
```java
// src/main/java/com/example/MySpringBootRoute.java
import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class MySpringBootRoute extends RouteBuilder {
    @Override
    public void configure() throws Exception {
        from("timer:hello?period=5000")
            .setBody(constant("Hello from Camel Spring Boot!"))
            .log("${body}");
    }
}
```

### Running
```bash
mvn spring-boot:run
```

**📚 For complete setup and configuration details, see:**
- [Camel Spring Boot](https://camel.apache.org/camel-spring-boot/next/index.html)
- [Spring Initializr with Camel](https://start.spring.io/) (search for "Camel")
- [Camel Spring Boot Starters](https://camel.apache.org/camel-spring-boot/next/list.html)

**🔗 GitHub Examples:**
- [Camel Spring Boot Examples](https://github.com/apache/camel-spring-boot-examples)

