FROM envoyproxy/envoy:v1.14-latest

# gettext-base contains envsubst used in the entrypoint
RUN apt-get update && \
    apt-get install gettext-base -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add placeholder TLS certificate assets
COPY certificate_chain.pem private_key.pem /etc/

# NOTE: The entrypoint.sh interpolates env vars and outputs /etc/envoy.yaml
COPY envoy.yaml.tmpl /tmpl/envoy.yaml.tmpl
COPY entrypoint.sh /
RUN chmod 500 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# By default, Envoy does a slow graceful shutdown
STOPSIGNAL SIGTERM

CMD ["/usr/local/bin/envoy", "-c", "/etc/envoy.yaml"]
