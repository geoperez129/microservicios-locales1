# === Etapa 1: construir dependencias con Composer ===
FROM composer:2 AS vendor

WORKDIR /app

# Copiamos archivos de Composer
COPY composer.json composer.lock ./

# Instalamos dependencias (sin dev)
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader

# === Etapa 2: imagen final con PHP + Nginx ===
FROM webdevops/php-nginx:8.2-alpine

WORKDIR /app

# Copiamos todo el proyecto
COPY . /app

# Copiamos la carpeta vendor desde la primera etapa
COPY --from=vendor /app/vendor /app/vendor

# Laravel sirve desde /public
ENV WEB_DOCUMENT_ROOT=/app/public

# Permisos para storage y cache
RUN chown -R application:application /app/storage /app/bootstrap/cache

# Usar usuario application
USER application

# Puerto HTTP
EXPOSE 80
