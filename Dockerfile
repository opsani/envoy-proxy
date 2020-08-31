FROM envoyproxy/envoy:v1.14-latest

ENV LISTEN_PORT=8080  \
    SERVICE_PORT=80   \
    METRICS_PORT=9901

ADD envoy.yaml /etc/envoy/
