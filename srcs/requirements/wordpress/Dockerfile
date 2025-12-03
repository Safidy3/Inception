# Use Debian Bookworm (penultimate stable)
FROM debian:bookworm

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install PHP, php-fpm, and required extensions
RUN apt-get update && apt-get install -y \
    php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-zip wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create WordPress directory
RUN mkdir -p /var/www/wordpress

# Download WordPress
WORKDIR /tmp
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress/* /var/www/wordpress \
    && rm -rf wordpress latest.tar.gz

# Set ownership
RUN chown -R www-data:www-data /var/www/wordpress

# Copy PHP-FPM configuration if needed
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Expose php-fpm port
EXPOSE 9000

# Start php-fpm
CMD ["php-fpm8.2", "-F"]
