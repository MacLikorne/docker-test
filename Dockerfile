FROM php:8.0-fpm-buster as php-base

RUN apt-get update && apt-get install -y libzip-dev libxml2-dev oniguruma-dev $PHPIZE_DEPS
RUN docker-php-ext-install zip mbstring simplexml bcmath pdo pdo_mysql opcache
RUN pecl install redis
RUN docker-php-ext-enable redis
RUN docker-php-source delete

RUN apt-get install nginx supervisor

COPY tools/docker/app/default.conf /etc/nginx/http.d/default.conf
COPY tools/docker/app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

FROM php-base as production

RUN mkdir -p /code/public
RUN echo "<?php echo 'hello world'; ?>" > /code/public/index.php

EXPOSE 80
