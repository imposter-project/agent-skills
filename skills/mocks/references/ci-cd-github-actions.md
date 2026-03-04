# CI/CD with GitHub Actions

Use the official [Imposter GitHub Actions](https://github.com/imposter-project/imposter-github-action) to run mock servers during your CI/CD pipeline.

## Available actions

### 1. Setup Imposter

Downloads and installs the Imposter CLI.

```yaml
- uses: imposter-project/imposter-github-action/setup@v1
```

### 2. Start Mocks

Starts the mock server in the background and waits for it to be ready.

```yaml
- uses: imposter-project/imposter-github-action/start-mocks@v1
  id: start-mocks
  with:
    config-dir: './mocks'           # default: './mocks'
    port: '8080'                    # default: '8080'
    version: ''                     # default: '' (latest)
    engine-type: 'docker'           # default: 'docker'
    recursive-config-scan: 'false'  # default: 'false'
```

**Advanced options:**

| Input | Description | Default |
|-------|-------------|---------|
| `auto-restart` | Restart on config change | `false` |
| `max-attempts` | Max readiness check attempts | `30` |
| `retry-interval` | Seconds between retries | `1` |

**Outputs:**

| Output | Description | Example |
|--------|-------------|---------|
| `base-url` | Base URL of the mock server | `http://localhost:8080` |

### 3. Stop Mocks

Stops the running mock server.

```yaml
- uses: imposter-project/imposter-github-action/stop-mocks@v1
  if: always()
  with:
    engine-type: 'docker'  # should match start-mocks
```

**Important:** Use `if: always()` to ensure the mock server is stopped even if tests fail.

## Complete workflow example

```yaml
name: Integration Tests with Mocks

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      # Install Imposter CLI
      - name: Setup Imposter
        uses: imposter-project/imposter-github-action/setup@v1

      # Start mock server
      - name: Start Mocks
        id: start-mocks
        uses: imposter-project/imposter-github-action/start-mocks@v1
        with:
          config-dir: './mocks'
          port: '8080'

      # Run your tests against the mock server
      - name: Run Tests
        run: |
          echo "Mock server at: ${{ steps.start-mocks.outputs.base-url }}"
          npm test
        env:
          API_BASE_URL: ${{ steps.start-mocks.outputs.base-url }}

      # Always stop the mock server
      - name: Stop Mocks
        if: always()
        uses: imposter-project/imposter-github-action/stop-mocks@v1
```

## Tips

- **Use the `base-url` output** to inject the mock server URL into your test configuration via environment variables.
- **Always stop mocks** with `if: always()` to avoid leaving containers running.
- **Pin action versions** to a specific release tag for reproducibility. Check the [latest release](https://github.com/imposter-project/imposter-github-action/releases).
- **Engine type consistency** - use the same `engine-type` in both `start-mocks` and `stop-mocks`.
- **Recursive config scan** - set `recursive-config-scan: 'true'` if your config files are in subdirectories.

## Repository layout

A typical project structure for CI/CD with mocks:

```
my-project/
├── .github/
│   └── workflows/
│       └── test.yml
├── mocks/
│   ├── users-config.yaml
│   ├── users-response.json
│   ├── orders-config.yaml
│   └── orders-response.json
├── src/
│   └── ...
└── tests/
    └── ...
```

## Links

- [imposter-github-action repository](https://github.com/imposter-project/imposter-github-action)
- [Configuration guide](https://docs.imposter.sh/configuration/)
