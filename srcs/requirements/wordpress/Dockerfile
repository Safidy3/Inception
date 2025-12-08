FROM debian:bookworm

# Install PHP, PHP-FPM, extensions, and curl for downloading WordPress
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip \
    php-cli php-opcache \
    mariadb-client \
    curl tar \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create directory for WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Download WordPress and extract it
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM pool config
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

CMD ["/usr/local/bin/entrypoint.sh"]
