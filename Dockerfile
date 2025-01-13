# Utilise une image PHP officielle avec Apache
FROM php:8.2-apache

# Installe les extensions PHP nécessaires pour Symfony
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install \
    pdo_mysql \
    pdo_pgsql \
    zip \
    opcache

# Active les modules Apache requis
RUN a2enmod rewrite

# Installe Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Définit le répertoire de travail dans le conteneur
WORKDIR /var/www/html

# Copie les fichiers de l'application dans le conteneur
COPY . .

# Installe les dépendances de Symfony
RUN composer install --no-dev --optimize-autoloader

# Donne les permissions nécessaires
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose le port 80 pour le serveur web
EXPOSE 80

# Commande par défaut pour démarrer Apache
CMD ["apache2-foreground"]
