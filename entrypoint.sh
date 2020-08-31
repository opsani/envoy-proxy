#!/bin/sh
set -e

export LISTEN_PORT=${LISTEN_PORT:-8080}
export SERVICE_PORT=${SERVICE_PORT:-80}
export METRICS_PORT=${METRICS_PORT:-9901}

echo "Generating envoy.yaml config file..."
cat /tmpl/envoy.yaml.tmpl | envsubst > /etc/envoy.yaml

echo "Starting Envoy..."
/usr/local/bin/envoy -c /etc/envoy.yaml
