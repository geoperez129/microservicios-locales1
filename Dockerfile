# === Etapa 1: instalar dependencias con Composer ===
FROM composer:2 AS vendor

WORKDIR /app

# Copiamos archivos de Composer
COPY composer.json composer.lock ./

# Instalamos dependencias SIN dev y SIN scripts (no corre artisan)
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

# === Etapa 2: imagen final con PHP + Nginx ===
FROM webdevops/php-nginx:8.2-alpine

WORKDIR /app

# Copiamos todo el proyecto
COPY . /app

# Copiamos la carpeta vendor desde la etapa anterior
COPY --from=vendor /app/vendor /app/vendor

# Laravel sirve desde /public
ENV WEB_DOCUMENT_ROOT=/app/public

# Crear carpetas necesarias y dar permisos
RUN mkdir -p /app/storage /app/bootstrap/cache \
    && chown -R application:application /app/storage /app/bootstrap/cache || true

# Usar usuario application
USER application

# Puerto HTTP
EXPOSE 80
