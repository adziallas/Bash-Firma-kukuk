# Build-Phase mit Node.js
FROM node:14 AS build
WORKDIR /app
COPY index.html main.js ./
RUN mkdir dist && \
    cp index.html dist/index.html && \
    cp main.js dist/main.js

# Bereitstellung über Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
