FROM envoyproxy/envoy:v1.14-latest

RUN apt-get update && \
    apt-get install gettext-base -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY envoy.yaml.tmpl /tmpl/envoy.yaml.tmpl
COPY entrypoint.sh /

RUN chmod 500 /entrypoint.sh

STOPSIGNAL SIGTERM
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml"]
