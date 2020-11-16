# Opsani Envoy Sidecar

This repository contains the reference configuration for [Envoy Proxy]() instances
injected into services integrating with Opsani for cloud infrastructure
optimization.

The sidecar is capable of generating the basic set of metrics necessary to
optimize an arbitrary web service orchestrated by Kubernetes.

## Configuration

The container is configured using a set of environment variables. Required values
are denoted with **bold** names. These values are interpolated into the `envoy.yaml.tmpl` configuration
template via the `entrypoint.sh` script run by the container.

| Name | Description | Default |
|------|-------------|---------|
| **`OPSANI_ENVOY_PROXY_SERVICE_PORT`** | The container port receiving HTTP or HTTPS traffic from a Kubernetes Service. | `80` |
| **`OPSANI_ENVOY_PROXIED_CONTAINER_PORT`** | The container port exposing the proxied HTTP or HTTPS application responsible for handling the requests. | `8080` |
| `OPSANI_ENVOY_PROXIED_CONTAINER_TLS_ENABLED` | Whether or not the `OPSANI_ENVOY_PROXIED_CONTAINER_PORT` is TLS encrypted (i.e. HTTPS or HTTP/2). Values are `true` or `false`. | `false` |
| `OPSANI_ENVOY_METRICS_PORT`| The HTTP port to expose Envoy admin metrics on. | `9901` |
| `OPSANI_ENVOY_PROXIED_CONTAINER_ADDR` | The address that the proxied container is bound to. This is only changed during development and testing. | `127.0.0.1` |

### TLS Configuration

When running in TLS mode, the following assets must be mounted into the container:

| Path | Description |
|------|-------------|
| `/etc/certificate_chain.pem` | A complete certificate chain in PEM format for negotiating TLS with the client. |
| `/etc/private_key.pem` | The private key in PEM format for accessing the certificate in order to present it to clients.

### Base Image

The Envoy base image can be overridden via the `ENVOY_BASE_IMAGE` Docker
build argument:

```console
docker build --build-arg ENVOY_BASE_IMAGE=other-envoy:latest .
```

## Testing

There is a Docker Compose configuration available that runs Nginx and the Envoy Proxy in a configuration that approximates
the environment of running in a sidecar deployment.

The configuration can be tested via curl:

| Task | Command | Env |
|------|---------|-----|
| Nginx via HTTP | `curl -v http://localhost:8280` | `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=80` |
| Envoy via HTTP | `curl -v http://localhost:8281` | `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=80` |
| Nginx via HTTPS | `curl -kv https://localhost:8643` | `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=80` |
| Envoy via HTTPS | `curl -v http://localhost:8281` |  `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=80, OPSANI_ENVOY_PROXIED_CONTAINER_TLS_ENABLED=true` |
| Envoy via HTTP to HTTPS | `curl -v https://localhost:8281` | `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=443` |
| Envoy via HTTPS to HTTPS | `curl -kv http://localhost:8281` |  `OPSANI_ENVOY_PROXIED_CONTAINER_PORT=443, OPSANI_ENVOY_PROXIED_CONTAINER_TLS_ENABLED=true` |

### Test Matrix

The above will be replaced with a proper test suite and build matrix shortly.

Required Cases:
- Get HTTP -> HTTP upstream
- Get HTTPS -> HTTPS upstream
- Get HTTP -> HTTPS upstream

Bonus cases:
- Get HTTP/1.1 -> HTTP/2 upstream
- Get HTTPS/1.1 -> HTTP/2 upstream
- Get HTTP/2 -> HTTP/1.1 upstream
- Get HTTP/2 -> HTTPS/1.1 upstream

## TODO

- Assign default ports with low collision likelihood.
- Enable SNI configuration for upstream TLS.
- Enable support for TLS validation context when proxying a TLS upstream.
- Enable support for upstream HTTP/2 via `OPSANI_ENVOY_PROXIED_CONTAINER_HTTP2_ENABLED`.
