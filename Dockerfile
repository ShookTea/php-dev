FROM php:8.2.1-fpm-alpine
MAINTAINER Norbert Kowalik <norbert.kowalik@icloud.com>

RUN apk add --no-cache git zip zlib-dev libzip-dev nginx supervisor icu-dev yarn linux-headers postgresql-dev $PHPIZE_DEPS \
        && curl --silent --show-error https://getcomposer.org/installer \
            | php -- --install-dir /usr/bin --filename composer \
        && mkdir /.composer \
        && chown 1000:1000 /.composer \
        && composer clear-cache \
        && composer config -g repo.packagist composer https://packagist.org \
        && composer config -g github-protocols https ssh \
        && docker-php-ext-install zip pdo pdo_pgsql pdo_mysql intl \
        && pecl install xdebug-3.2.0 \
        && docker-php-ext-enable xdebug \
        && mkdir -p /run/nginx

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /usr/share/nginx/html/backend
EXPOSE 80
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf

