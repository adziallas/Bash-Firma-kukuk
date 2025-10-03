# Basis-Image: schlanker Webserver
FROM nginx:alpine

# Entferne Standard-Nginx-Inhalte
RUN rm -rf /usr/share/nginx/html/*

# Kopiere statische Dateien ins Webverzeichnis
COPY . /usr/share/nginx/html

# Exponiere Port 80
EXPOSE 80

# Starte Nginx (Standard-Eintragspunkt bleibt erhalten)
