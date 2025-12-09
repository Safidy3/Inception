#!/bin/bash
set -e

echo ">>> MariaDB ENTRYPOINT STARTED"

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo ">>> No '${MYSQL_DATABASE}' database detected, initializing..."

    mariadb-install-db --user=mysql --ldata=/var/lib/mysql

    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${WP_USER}'@'%' IDENTIFIED BY '${WP_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${WP_USER}'@'%';

CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${WP_ADMIN_USER}'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    echo ">>> MariaDB init completed."
else
    echo ">>> Existing DB found, skipping initialization."
fi

echo ">>> Launching MariaDB"
exec "$@"
