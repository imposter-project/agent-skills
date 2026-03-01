# Embedding Imposter in JVM Tests

Embed Imposter directly in your JUnit or TestNG tests. The mock server starts before your tests and provides synthetic HTTP responses to your component under test.

## Prerequisites

- Java 11+
- A JVM build tool (Gradle or Maven)

## Getting started

Add the Imposter Maven repository and dependencies to your build tool.

**Maven repository URL:**

```
https://s3-eu-west-1.amazonaws.com/gatehillsoftware-maven/releases
```

**Required dependencies:**

| Component | Group ID | Artifact ID |
|-----------|----------|-------------|
| Main library | `io.gatehill.imposter` | `distro-embedded` |
| HTTP server | `io.gatehill.imposter` | `imposter-server` |
| Config parser | `io.gatehill.imposter` | `config-dynamic` |
| OpenAPI plugin | `io.gatehill.imposter` | `mock-openapi` |

Check the [latest version](https://github.com/imposter-project/imposter-jvm-engine/releases).

## Gradle setup

```groovy
ext {
    imposter_version = '4.2.2'
}

repositories {
    maven {
        url 'https://s3-eu-west-1.amazonaws.com/gatehillsoftware-maven/releases/'
    }
}

dependencies {
    testImplementation "io.gatehill.imposter:distro-embedded:$imposter_version"
    testImplementation "io.gatehill.imposter:imposter-server:$imposter_version"
    testImplementation "io.gatehill.imposter:config-dynamic:$imposter_version"
    testImplementation "io.gatehill.imposter:mock-openapi:$imposter_version"
}
```

## Maven setup

```xml
<repositories>
    <repository>
        <id>imposter</id>
        <url>https://s3-eu-west-1.amazonaws.com/gatehillsoftware-maven/releases</url>
    </repository>
</repositories>

<properties>
    <imposter.version>4.2.2</imposter.version>
</properties>

<dependencies>
    <dependency>
        <groupId>io.gatehill.imposter</groupId>
        <artifactId>distro-embedded</artifactId>
        <version>${imposter.version}</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.gatehill.imposter</groupId>
        <artifactId>imposter-server</artifactId>
        <version>${imposter.version}</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.gatehill.imposter</groupId>
        <artifactId>config-dynamic</artifactId>
        <version>${imposter.version}</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.gatehill.imposter</groupId>
        <artifactId>mock-openapi</artifactId>
        <version>${imposter.version}</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

## Usage with OpenAPI spec

Use `OpenApiImposterBuilder` when you have an OpenAPI specification:

```java
import io.gatehill.imposter.openapi.embedded.OpenApiImposterBuilder;

Path specFile = Paths.get("/path/to/openapi_file.yaml");

MockEngine imposter = new OpenApiImposterBuilder<>()
        .withSpecificationFile(specFile)
        .startBlocking();

// mockEndpoint will look like http://localhost:5234/v1/pets
String mockEndpoint = imposter.getBaseUrl() + "/v1/pets";

// Your component under test uses this endpoint
```

## Usage with configuration files

Use `ImposterBuilder` with a standard Imposter configuration directory:

```java
import io.gatehill.imposter.embedded.ImposterBuilder;
import io.gatehill.imposter.openapi.OpenApiPluginImpl;

String configDir = Paths.get("/path/to/config_dir");

MockEngine imposter = new ImposterBuilder<>()
        .withPluginClass(OpenApiPluginImpl.class)
        .withConfigurationDir(configDir)
        .startBlocking();

String mockEndpoint = imposter.getBaseUrl() + "/v1/pets";
```

## JUnit 5 example

```java
import org.junit.jupiter.api.*;
import io.gatehill.imposter.openapi.embedded.OpenApiImposterBuilder;

class PetServiceTest {
    static MockEngine imposter;

    @BeforeAll
    static void setUp() {
        imposter = new OpenApiImposterBuilder<>()
                .withSpecificationFile(Paths.get("src/test/resources/petstore.yaml"))
                .startBlocking();
    }

    @AfterAll
    static void tearDown() {
        if (imposter != null) {
            imposter.close();
        }
    }

    @Test
    void shouldFetchPets() throws Exception {
        var url = new URL(imposter.getBaseUrl() + "/pets");
        var connection = (HttpURLConnection) url.openConnection();
        assertEquals(200, connection.getResponseCode());
    }
}
```

## Other plugins

| Component | Artifact ID | Documentation |
|-----------|-------------|---------------|
| SOAP/WSDL mocks | `mock-soap` | [SOAP plugin](https://docs.imposter.sh/soap_plugin/) |
| RESTful mocks | `mock-rest` | [REST plugin](https://docs.imposter.sh/rest_plugin/) |

## Links

- [JVM engine releases](https://github.com/imposter-project/imposter-jvm-engine/releases)
- [JUnit sample project](https://github.com/imposter-project/examples/tree/main/junit-sample)
- [Plugins documentation](https://docs.imposter.sh/plugins/)
