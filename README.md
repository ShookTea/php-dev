# php-dev

My custom PHP Docker image for development, built on fpm-alpine image with
nginx installed. Made for use with Symfony.

Example `docker-compose` file:

```yaml
version: "3"
services:
  php:
    image: ghcr.io/shooktea/php-dev/php-dev:8.3.9.0
    volumes:
      - "./backend:/usr/share/nginx/html/backend"
    ports:
      - "8080:80"
```

