---
name: imposter
description: >
  Use this skill when the user wants to mock APIs, create HTTP test doubles, or
  work with the Imposter mock engine. Covers starting and stopping mock servers
  with the Imposter CLI (imposter up, imposter down, imposter list), running
  mocks in Docker containers, scaffolding mock configuration from OpenAPI specs,
  checking mock server health, and configuring REST, OpenAPI, and SOAP mock
  endpoints. Also covers CI/CD integration with GitHub Actions, embedding mocks
  in JVM (JUnit/TestNG) tests, and using the imposter-js Node.js library.
  Keywords: mock server, API mocking, imposter, REST, OpenAPI, SOAP, test
  doubles, HTTP mock, stub server, service virtualisation.
---

# Imposter Mock Engine

Imposter is a mock server for REST APIs, OpenAPI (and Swagger) specifications, SOAP web services, and more. Use it to create realistic test doubles that run locally or in CI/CD pipelines.

## Installation

### Prerequisites

You need **one** of the following runtimes:

- **Docker** (recommended) - [Install Docker](https://docs.docker.com/get-docker/)
- **JVM** (Java 11+)

### Install the CLI

**Homebrew (macOS/Linux):**

```bash
brew tap imposter-project/imposter
brew install imposter
```

**Shell script (macOS/Linux):**

```bash
curl -L https://raw.githubusercontent.com/imposter-project/imposter-cli/main/install/install_imposter.sh | bash -
```

For other installation options, see the [full installation guide](https://github.com/imposter-project/imposter-cli/blob/main/docs/install.md).

### Verify installation

```bash
imposter version
```

## Quick start

### 1. Create a mock configuration

Create a file named `my-api-config.yaml`:

```yaml
plugin: rest
path: /hello
response:
  content: '{"message": "Hello, World!"}'
  statusCode: 200
  headers:
    Content-Type: application/json
```

### 2. Start the mock server

```bash
imposter up
```

The CLI auto-discovers configuration files (those ending in `-config.yaml` or `-config.json`) in the current directory.

### 3. Test the mock

```bash
curl http://localhost:8080/hello
```

### 4. Stop the mock server

```bash
imposter down
```

## CLI commands

### imposter up

Start the mock server.

```bash
# Start from current directory on default port (8080)
imposter up

# Start from a specific directory
imposter up /path/to/config

# Start on a specific port
imposter up -p 3000

# Choose engine type
imposter up -t docker       # Docker core (default, common plugins)
imposter up -t docker-all   # Docker all (all plugins)
imposter up -t jvm           # JVM engine (requires Java 11+)
```

**Key flags:**

| Flag | Description | Default |
|------|-------------|---------|
| `-p, --port` | Server port | `8080` |
| `-t, --engine-type` | Engine: `docker`, `docker-all`, `docker-core`, `jvm` | `docker` |
| `-e, --env` | Set environment variable (e.g. `-e KEY=VALUE`) | |
| `--debug-mode` | Enable JVM debug on port 8000 | |

### imposter down

Stop the running mock server.

```bash
imposter down
```

### imposter list

List running mock servers.

```bash
imposter list
```

### imposter scaffold

Generate configuration from an OpenAPI specification.

```bash
# Scaffold from OpenAPI specs in the current directory
imposter scaffold

# Scaffold from a specific directory
imposter scaffold /path/to/specs
```

This creates `-config.yaml` files for each OpenAPI spec found, setting up the `openapi` plugin with resources derived from the spec's paths and methods.

### imposter doctor

Check your Imposter installation.

```bash
imposter doctor
```

This verifies that the CLI, engine (Docker or JVM), and configuration are correctly set up.

## Checking if the server is up

### Status endpoint

Imposter exposes a health check endpoint:

```bash
curl http://localhost:8080/system/status
```

Returns HTTP 200 with `{"status":"ok"}` when healthy.

### Using the bundled health check script

```bash
# Check if mock server is healthy on default port
./scripts/healthcheck.sh

# Check on a custom port
./scripts/healthcheck.sh --port 3000
```

### Using the bundled wait script

Wait for the mock server to become ready (useful in scripts and CI):

```bash
# Wait up to 30 seconds for the server
./scripts/wait-for-mock.sh

# Custom timeout and port
./scripts/wait-for-mock.sh --port 3000 --timeout 60
```

## Configuration basics

### File naming

Configuration files must end with `-config.yaml` or `-config.json`. Examples: `petstore-config.yaml`, `users-api-config.json`.

### Plugins

| Plugin | Use case | Config key |
|--------|----------|------------|
| `rest` | Plain REST endpoints | `plugin: rest` |
| `openapi` | OpenAPI/Swagger specifications | `plugin: openapi` |
| `soap` | SOAP/WSDL web services | `plugin: soap` |

### REST plugin example

```yaml
plugin: rest
path: /users
method: GET
contentType: application/json
response:
  file: users.json
  statusCode: 200
```

### OpenAPI plugin example

```yaml
plugin: openapi
specFile: petstore.yaml
```

When using the `openapi` plugin, Imposter serves responses from the `examples` in the OpenAPI spec automatically.

### Multiple resources

```yaml
plugin: rest
resources:
  - path: /users
    method: GET
    response:
      file: users.json
  - path: /users
    method: POST
    response:
      statusCode: 201
      content: '{"id": 1}'
```

### Conditional responses

Match on query parameters, path parameters, or headers:

```yaml
plugin: rest
resources:
  - path: /users
    method: GET
    queryParams:
      role: admin
    response:
      file: admin-users.json
  - path: /users/{userId}
    method: GET
    pathParams:
      userId: "42"
    response:
      file: user-42.json
```

### Environment variables in config

```yaml
plugin: rest
path: /example
response:
  content: "${env.EXAMPLE_RESPONSE:-default value}"
```

Environment variables can also be loaded from a `.env` file placed alongside the configuration files.

For detailed configuration options including scripted responses, request body matching, data capture, and stores, see [references/configuration.md](references/configuration.md).

## Running with Docker directly

If you prefer to use Docker without the CLI:

```bash
docker run -v $PWD:/opt/imposter/config -p 8080:8080 outofcoffee/imposter
```

For Docker image variants and advanced usage, see [references/docker.md](references/docker.md).

## Running as a JAR

If you have Java 11+ installed:

```bash
java -jar imposter-all.jar --plugin rest --configDir ./config
```

## Other ways to use Imposter

- **CI/CD with GitHub Actions** - see [references/ci-cd-github-actions.md](references/ci-cd-github-actions.md)
- **Embed in JVM tests (JUnit/TestNG)** - see [references/jvm-embedding.md](references/jvm-embedding.md)
- **Embed in JavaScript/Node.js tests** - see [references/imposter-js.md](references/imposter-js.md)
- **Detailed configuration reference** - see [references/configuration.md](references/configuration.md)
- **Docker deployment** - see [references/docker.md](references/docker.md)

## Troubleshooting

### Port already in use

If port 8080 is taken, use a different port:

```bash
imposter up -p 3000
```

### No configuration files found

Ensure your config files end with `-config.yaml` or `-config.json` and are in the directory you're running from.

### Plugin not found

The default `docker` engine type includes common plugins (rest, openapi, soap). For additional plugins, use the `docker-all` engine type:

```bash
imposter up -t docker-all
```

### Docker not running

If you see connection errors, verify Docker is running:

```bash
docker info
```

Or switch to the JVM engine type:

```bash
imposter up -t jvm
```

### Check installation health

```bash
imposter doctor
```

## Links

- [Imposter documentation](https://docs.imposter.sh)
- [Imposter CLI repository](https://github.com/imposter-project/imposter-cli)
- [Configuration examples](https://github.com/imposter-project/examples)
- [Imposter GitHub Actions](https://github.com/imposter-project/imposter-github-action)
