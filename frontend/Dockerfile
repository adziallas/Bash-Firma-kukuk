# Build-Phase mit Node.js
FROM node:14 AS build
WORKDIR /app

# Kopiere nur relevante Dateien
COPY index.html main.js ./

# Optional: Minifizierung oder andere Build-Schritte
# Beispiel: Kopiere Dateien in ein dist-Verzeichnis
RUN mkdir dist && \
    cp index.html dist/index.html && \
    cp main.js dist/main.js

# Bereitstellung über Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
