# Build-Phase mit Node.js
FROM node:14 AS build
WORKDIR /app

# Kopiere das gesamte Frontend-Projekt
COPY . ./

# Installiere Abhängigkeiten und baue das Projekt
RUN npm install && npm run build

# Bereitstellung über Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
