FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Remove default site configs
RUN rm -f /etc/nginx/sites-enabled/default

# Copy our nginx config
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy setup script for certificate preparation
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Expose HTTPS only
EXPOSE 443

ENTRYPOINT ["setup.sh"]

CMD ["nginx", "-g", "daemon off;"]
