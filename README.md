# Bash-Firma Kukuk

Stabile, reproduzierbare Demo-Umgebung für Spring Boot + statisches Frontend.

## Komponenten

- **Backend**: Spring Boot, REST API, Profile `dev` und `prod`
- **Frontend**: Statisches HTML/JS, ausgeliefert via Nginx
- **CI/CD**: Jenkins mit manuellem Build-Trigger
- **Docker**: Multi-Stage Builds für schlanke Images
- **Kubernetes**: Deployments für `dev` und `prod` mit Namespace-Isolation

## Starten

```bash
# Backend lokal bauen
mvn clean package -Pprod -DskipTests

# Docker-Image bauen
docker build -t kukuk-backend:latest .

# Container starten
docker run -d -p 8080:8080 -e SPRING_PROFILES_ACTIVE=prod --name kukuk-prod kukuk-backend:latest

Deployment-Check
bash
curl -s http://localhost:8080/
# Erwartet: "Willkommen bei Bash-Firma Kukuk!"

leanup
bash
./cleanup-kukuk.sh
# Entfernt .trunk/, node_modules/, target/
Zugang für Demos
Pinggy.io

Zugangsdaten manuell verwaltet, keine CI-Weitergabe



