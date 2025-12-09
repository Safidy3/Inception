# Use penultimate stable Debian (example: bookworm) – adjust if needed
FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Ensure MariaDB data directory exists
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

# Copy custom config & initialization script
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/init-db.sh /usr/local/bin/init-db.sh

RUN chmod +x /usr/local/bin/init-db.sh

# Expose DB port (internal only, docker-network)
EXPOSE 3306

# ENTRYPOINT runs the init script, which handles first-run DB setup
ENTRYPOINT ["init-db.sh"]

# Run mysqld in foreground (required by Inception)
CMD ["mysqld"]
