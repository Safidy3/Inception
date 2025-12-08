#!/bin/bash
set -e

echo "Waiting for MariaDB to be ready..."
until mariadb -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 1
done

echo "MariaDB is ready."

# If wp-config.php doesn't exist, create it
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."

    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
    sed -i "s/localhost/${MYSQL_HOST}/" /var/www/html/wp-config.php

    # Add salts
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php

    echo "WP config created."
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "WordPress installed successfully!"
else
    echo "WordPress is already installed."
fi

# Permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
php-fpm8.2 -F
