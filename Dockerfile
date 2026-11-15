# ---------------------------------------------------------
# Imagen del servicio web de reserva de horas médicas
# Base: nginx:alpine (oficial y liviana)
# ---------------------------------------------------------
FROM nginx:alpine

LABEL maintainer="Proyecto DevOps integrador - IACC 2026" \
      description="Sitio estático de reserva de horas médicas servido con Nginx" \
      version="1.0.0"

# Copia los archivos estáticos del sitio al directorio que sirve Nginx
COPY src/ /usr/share/nginx/html/

# Puerto interno del contenedor (se publica como 8080 en docker-compose.yml)
EXPOSE 80

# Verificación de salud: comprueba que Nginx responda dentro del contenedor
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1
