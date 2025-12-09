#!/bin/bash
set -e

echo ">>> MariaDB ENTRYPOINT STARTED"

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo ">>> No '${MYSQL_DATABASE}' database detected, initializing..."

    mariadb-install-db --user=mysql --ldata=/var/lib/mysql

    mysqld --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${WP_ADMIN_USER}'@'%';

ALTER USER '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

    echo ">>> MariaDB init completed."
else
    echo ">>> Existing DB found, skipping initialization."
fi

echo ">>> Launching MariaDB"
exec "$@"
