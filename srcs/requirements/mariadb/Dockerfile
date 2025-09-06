FROM debian:bullseye

RUN apt-get update  \
	&& apt-get install -y mariadb-server  \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/init.sql /docker-entrypoint-initdb.d/

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

EXPOSE 3306

CMD ["mysqld_safe"]
