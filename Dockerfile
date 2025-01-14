FROM jenkins/agent

USER root
RUN apt-get update && apt-get install -y docker.io

FROM php:8.1-fpm

# Install required extensions
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/symfony

# Copy the Symfony application
COPY . .

# Install Symfony dependencies
RUN composer install --no-scripts --no-progress --prefer-dist
