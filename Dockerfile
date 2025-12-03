# Imagen base con PHP 8.2 + Nginx
FROM webdevops/php-nginx:8.2-alpine

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copiamos solo composer.json y composer.lock primero (mejora la caché)
COPY composer.json composer.lock ./

# Instalamos las dependencias de Laravel SIN scripts (no corre artisan)
RUN composer install --no-dev --no-interaction --no-scripts --optimize-autoloader

# Ahora copiamos todo el proyecto
COPY . /app

# Carpeta pública de Laravel
ENV WEB_DOCUMENT_ROOT=/app/public

# Permisos para storage y cache
RUN chown -R application:application /app/storage /app/bootstrap/cache

# Usamos el usuario application
USER application

# Puerto por el que va a escuchar Nginx
EXPOSE 80
