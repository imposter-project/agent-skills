# Running Imposter with Docker

Run Imposter as a Docker container without using the CLI.

## Docker images

| Image | Docker Hub | ECR | Plugins | Notes |
|-------|-----------|-----|---------|-------|
| **core** | `outofcoffee/imposter` | `public.ecr.aws/imposter/imposter` | openapi, rest, soap | Recommended for most users |
| **all** | `outofcoffee/imposter-all` | `public.ecr.aws/imposter/imposter-all` | All plugins | Largest image |
| **distroless** | `outofcoffee/imposter-distroless` | `public.ecr.aws/imposter/imposter-distroless` | Same as core | Smallest image. **v4 only** |

### Versions

Both Imposter v4 and v5 publish `core` and `all` images, so Docker is a first-class way to run either. Pick with a tag:

```bash
docker run -v $PWD:/opt/imposter/config -p 8080:8080 outofcoffee/imposter:5.0.0
```

The distroless image is v4 only. v5 has no JVM-based variant; its Docker images wrap the same engine as the native binary, so the v5 caveats apply in the container too — JavaScript scripting only (no Groovy), no passthrough/proxy responses, and no remote configuration sources.

If you want v5 without a container runtime at all, use the CLI's `native` engine type instead — see the main skill's Engine types section.

## Basic usage

Mount your configuration directory to `/opt/imposter/config` inside the container:

```bash
docker run -v $PWD:/opt/imposter/config -p 8080:8080 outofcoffee/imposter
```

### Custom port

```bash
docker run -v $PWD:/opt/imposter/config -p 3000:8080 outofcoffee/imposter
```

### All plugins

```bash
docker run -v $PWD:/opt/imposter/config -p 8080:8080 outofcoffee/imposter-all
```

### With environment variables

```bash
docker run -v $PWD:/opt/imposter/config -p 8080:8080 \
  -e IMPOSTER_LOG_LEVEL=DEBUG \
  outofcoffee/imposter
```

## Build a self-contained image

Create a portable image with your configuration baked in:

```dockerfile
FROM outofcoffee/imposter
COPY ./config/* /opt/imposter/config/
```

Build and run:

```bash
docker build -t my-mock .
docker run -p 8080:8080 my-mock
```

## Docker Compose

```yaml
version: '3'
services:
  mock-api:
    image: outofcoffee/imposter
    ports:
      - "8080:8080"
    volumes:
      - ./mocks:/opt/imposter/config
```

## Configuration path

All configuration files must be placed at `/opt/imposter/config` inside the container. Files referenced from configuration (response files, scripts, etc.) are resolved relative to this path.

## Links

- [Docker Hub - outofcoffee/imposter](https://hub.docker.com/r/outofcoffee/imposter)
- [Imposter Docker documentation](https://docs.imposter.sh/run_imposter_docker/)
