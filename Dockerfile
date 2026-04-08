
FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    nginx \
    git \
    unzip \
    curl \
    libzip-dev \
    oniguruma-dev \
    bash

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    mbstring

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader

RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
