# Basis-Image mit Java 17 Runtime
FROM eclipse-temurin:17-jre

# Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere das JAR ins Container-Dateisystem (dynamisch)
COPY target/*.jar app.jar

# Exponiere den Port (optional, für Dokumentation)
EXPOSE 8080

# Startbefehl
ENTRYPOINT ["java", "-jar", "app.jar"]
