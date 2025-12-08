# Etapa 1: solo para obtener Composer
FROM composer:2 AS composer_stage

# Etapa 2: imagen principal con PHP
FROM php:8.2-cli-alpine

# Instalamos extensiones necesarias para Laravel y MySQL
RUN apk add --no-cache \
    git \
    unzip \
    libpng-dev \
    libzip-dev \
    oniguruma-dev \
    mysql-client \
 && docker-php-ext-install pdo_mysql

# Carpeta de la aplicación
WORKDIR /app

# Copiamos todo el proyecto Laravel
COPY . .

# Copiamos el binario de composer desde la primera etapa
COPY --from=composer_stage /usr/bin/composer /usr/bin/composer

# Instalamos dependencias de Laravel (incluyendo scripts)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Creamos usuario no-root para cumplir con Render
RUN adduser -D appuser
USER appuser

# Puerto donde escuchará Laravel
EXPOSE 10000

# Comando de arranque: servidor integrado de Laravel
CMD php artisan serve --host=0.0.0.0 --port=10000
