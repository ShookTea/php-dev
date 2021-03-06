FROM php:7.4.12-fpm-alpine
MAINTAINER Norbert Kowalik <norbert.kowalik@icloud.com>

RUN apk add --no-cache git zip zlib-dev libzip-dev nginx supervisor icu-dev yarn $PHPIZE_DEPS \
        && curl --silent --show-error https://getcomposer.org/installer \
            | php -- --install-dir /usr/bin --filename composer \
        && mkdir /.composer \
        && chown 1000:1000 /.composer \
        && composer clear-cache \
        && composer config -g repo.packagist composer https://packagist.org \
        && composer config -g github-protocols https ssh \
        && composer global require hirak/prestissimo \
        && docker-php-ext-install zip pdo_mysql intl \
        && pecl install xdebug-2.9.0 \
        && docker-php-ext-enable xdebug \
        && mkdir -p /run/nginx

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /usr/share/nginx/html/backend
EXPOSE 80
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf

