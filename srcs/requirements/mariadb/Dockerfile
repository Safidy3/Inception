
FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y mariadb-server

COPY ./tools/init-db.sh /usr/local/bin/init-db.sh

RUN  chmod +x /usr/local/bin/init-db.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 
COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT ["bash", "/usr/local/bin/init-db.sh"]
CMD ["mysqld_safe"]
