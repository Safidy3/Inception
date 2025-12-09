#!/bin/bash
set -e

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Creating wp-config.php..."

	cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

	sed -i "s/database_name_here/${MYSQL_DATABASE}/"	/var/www/html/wp-config.php
	sed -i "s/username_here/${WP_ADMIN_USER}/"			/var/www/html/wp-config.php
	sed -i "s/password_here/${WP_ADMIN_PASSWORD}/"		/var/www/html/wp-config.php
	sed -i "s/localhost/${MYSQL_HOST}/"					/var/www/html/wp-config.php

	echo "WP config created."
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
	echo "Installing WordPress..."
	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root

	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--user_pass="${WP_PASSWORD}" \
		--allow-root

	echo "WordPress installed successfully!"
else
	echo "WordPress is already installed."
fi

# Permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec "$@"
