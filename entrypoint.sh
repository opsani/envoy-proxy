#!/bin/sh
set -e

export OPSANI_ENVOY_PROXY_SERVICE_PORT=${OPSANI_ENVOY_PROXY_SERVICE_PORT:-80}
export OPSANI_ENVOY_PROXIED_CONTAINER_PORT=${OPSANI_ENVOY_PROXIED_CONTAINER_PORT:-8080}
export OPSANI_ENVOY_METRICS_PORT=${OPSANI_ENVOY_METRICS_PORT:-9901}

echo "Generating envoy.yaml config file..."
cat /tmpl/envoy.yaml.tmpl | envsubst > /etc/envoy.yaml

echo "---"
cat /etc/envoy.yaml
echo "---\n"

echo "Starting Envoy..."
exec "$@"
