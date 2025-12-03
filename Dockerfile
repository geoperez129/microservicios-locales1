# Imagen con PHP + Nginx lista para producción
FROM webdevops/php-nginx:8.2-alpine

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copiamos todo el proyecto
COPY . /app

# Indicamos que la carpeta pública de Laravel es el docroot
ENV WEB_DOCUMENT_ROOT=/app/public

# Instalamos las dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Damos permisos a storage y cache
RUN chown -R application:application /app/storage /app/bootstrap/cache

# Usar el usuario application (buena práctica)
USER application

# Render va a entrar por el puerto 80 del contenedor
EXPOSE 80
