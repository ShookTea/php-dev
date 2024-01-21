FROM php:8.3.2-fpm-alpine
MAINTAINER Norbert Kowalik <norbert.kowalik@icloud.com>

RUN apk add --no-cache git \
    zip zlib-dev libzip-dev nginx supervisor icu-dev yarn linux-headers postgresql-dev \
    rabbitmq-c rabbitmq-c-dev $PHPIZE_DEPS

RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir /usr/bin --filename composer
RUN mkdir /.composer
RUN chown 1000:1000 /.composer
RUN composer clear-cache
RUN composer config -g repo.packagist composer https://packagist.org
RUN composer config -g github-protocols https ssh

RUN docker-php-ext-install zip pdo pdo_pgsql pdo_mysql intl
RUN pecl install xdebug amqp
RUN docker-php-ext-enable xdebug amqp

RUN mkdir -p /run/nginx

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /usr/share/nginx/html/backend
EXPOSE 80
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf

