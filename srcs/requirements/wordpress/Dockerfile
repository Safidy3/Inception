FROM debian:bullseye

RUN apt-get update && apt-get install -y php-fpm php-mysql wget curl && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xvzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
