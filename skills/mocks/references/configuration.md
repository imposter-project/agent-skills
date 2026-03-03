# Configuration Reference

Detailed reference for Imposter mock configuration files.

## File naming

Configuration files must end with `-config.yaml`, `-config.yml`, or `-config.json`.

Examples: `petstore-config.yaml`, `users-api-config.json`

## Plugins

| Plugin | Config key | Use case |
|--------|-----------|----------|
| REST | `plugin: rest` | Plain REST/HTTP endpoints |
| OpenAPI | `plugin: openapi` | OpenAPI/Swagger specifications |
| SOAP | `plugin: soap` | SOAP/WSDL web services |
| HBase | `plugin: hbase` | HBase mock (requires `docker-all`) |
| SFDC | `plugin: sfdc` | Salesforce mock (requires `docker-all`) |

## REST plugin

### Simple static response

```yaml
plugin: rest
path: /example
response:
  file: example-data.json
```

### Full response options

```yaml
plugin: rest
path: /example
method: POST
contentType: application/json
response:
  file: data.json
  statusCode: 201
  headers:
    X-Custom-Header: foo
```

### Multiple resources

```yaml
plugin: rest
resources:
  - path: /users
    method: GET
    response:
      file: users.json
      statusCode: 200

  - path: /users
    method: POST
    response:
      statusCode: 201
      content: '{"id": 1, "created": true}'
```

### Inline response content

```yaml
plugin: rest
path: /health
response:
  statusCode: 200
  content: |
    {"status": "ok"}
  headers:
    Content-Type: application/json
```

## OpenAPI plugin

### Basic usage

```yaml
plugin: openapi
specFile: petstore.yaml
```

When using the OpenAPI plugin, Imposter automatically serves responses from `examples` defined in the specification.

### With custom resources

```yaml
plugin: openapi
specFile: petstore.yaml
resources:
  - method: GET
    path: /pets
    response:
      statusCode: 200
      file: custom-pets.json
```

## Scaffolding from OpenAPI

Generate configuration files automatically:

```bash
# Place your OpenAPI spec in the current directory
imposter scaffold

# Output:
# found 1 OpenAPI spec(s)
# generated 1 resources from spec
# wrote Imposter config: petstore-config.yaml
```

## Conditional responses

### By query parameters

```yaml
plugin: rest
resources:
  - path: /users
    method: GET
    queryParams:
      role: admin
    response:
      file: admin-users.json

  - path: /users
    method: GET
    response:
      file: all-users.json
```

### By path parameters

```yaml
plugin: openapi
specFile: api.yaml
resources:
  - path: /users/{userId}
    method: GET
    pathParams:
      userId: "42"
    response:
      file: user-42.json
```

### By request headers

```yaml
plugin: rest
resources:
  - path: /api
    method: GET
    requestHeaders:
      X-Api-Key: secret-key
    response:
      statusCode: 200
      file: data.json

  - path: /api
    method: GET
    response:
      statusCode: 401
      content: '{"error": "unauthorized"}'
```

### Wildcard path matching

```yaml
plugin: rest
resources:
  - path: /api/v1/*
    method: GET
    response:
      statusCode: 200
      content: '{"matched": "wildcard"}'
```

## Response defaults

| Field | Default | Example |
|-------|---------|---------|
| `contentType` | `application/json` | `text/plain` |
| `response.statusCode` | `200` | `201` |
| `response.content` | empty | `hello world` |
| `response.file` | empty | `data.json` |
| `response.headers` | empty | `{"X-Header": "value"}` |

### Default response configuration

Apply defaults to all resources:

```yaml
plugin: rest
defaultsFromRootResponse: true
response:
  headers:
    X-Powered-By: Imposter

resources:
  - path: /endpoint1
    method: GET
    response:
      content: "Hello"

  - path: /endpoint2
    method: GET
    response:
      content: "World"
```

Both responses will include the `X-Powered-By` header.

## Environment variables in config

Use environment variables as placeholders:

```yaml
plugin: rest
path: /example
response:
  content: "${env.RESPONSE_DATA}"
```

### Default values

```yaml
response:
  content: "${env.RESPONSE_DATA:-fallback value}"
```

### Environment file

Place a `.env` file alongside your configuration:

```
IMPOSTER_LOG_LEVEL=info
RESPONSE_DATA=hello
```

## Config file discovery

By default, Imposter reads configuration files from the top-level directory only. To scan subdirectories:

```bash
# CLI
imposter up -e IMPOSTER_CONFIG_SCAN_RECURSIVE=true

# Docker
docker run -e IMPOSTER_CONFIG_SCAN_RECURSIVE=true ...
```

## Scripted responses

For advanced scenarios, use JavaScript or Groovy scripts:

```yaml
plugin: rest
path: /dynamic
response:
  scriptFile: handler.js
```

Example `handler.js`:

```javascript
if (context.request.queryParams.name) {
    respond()
        .withStatusCode(200)
        .withContent('Hello, ' + context.request.queryParams.name);
} else {
    respond()
        .withStatusCode(400)
        .withContent('Missing name parameter');
}
```

## System endpoints

| Endpoint | Description |
|----------|-------------|
| `/system/status` | Health check - returns `{"status":"ok"}` when healthy |
| `/system/metrics` | Prometheus-format metrics |
| `/_spec` | OpenAPI specification UI (when using openapi plugin) |

## Links

- [Full configuration guide](https://docs.imposter.sh/configuration/)
- [Request matching](https://docs.imposter.sh/request_matching/)
- [Scripting guide](https://docs.imposter.sh/scripting/)
- [Templates](https://docs.imposter.sh/templates/)
- [Data capture](https://docs.imposter.sh/data_capture/)
- [Stores](https://docs.imposter.sh/stores/)
- [Configuration examples](https://github.com/imposter-project/examples)
