# Build-Phase: React mit Node.js
FROM node:18 AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . ./
RUN npm run build

# Bereitstellung über Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

# Korrigierter Pfad: React erzeugt /app/build
COPY --from=build /app/build/ ./

EXPOSE 80
