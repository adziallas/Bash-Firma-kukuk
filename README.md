# Abschlussprojekt – DevOps Engineering bei Kukuk Technology Future GmbH
## Lizenz
Dieses Projekt steht unter keiner speziellen Lizenz. Nutzung zu Lern- und Demonstrationszwecken erlaubt.
## Hinweise
Die Jenkins-Pipeline ist so konfiguriert, dass sie bei Produktions-Deploys auf eine manuelle Bestätigung wartet.

Die Kubernetes-Konfiguration nutzt kubeadm über Docker Desktop.

Für Live-Demos empfiehlt sich ein Clean Start mit den obigen Befehlen.


**ANMERKUNG**  
1. Zu diesem Repo gehört ein automatisiertes Bash-Skript was im Ordner unten angehangen.
   # Dateiname: programme-installation-firma-kukuk.sh
   # Freigabe ggf. mit
   "mit chmod +x programme-installation-firma-kukuk.sh" freigeben" 
   das alle benötigten Programme wird installiert

3. Ich habe die Jenkins-Pipeline nur lokal getestet unter `http://localhost:9090`.  
   Da kein externer Zugriff möglich ist, habe ich einen Screenshot angehängt:

![Jenkins Screenshot](https://github.com/user-attachments/assets/7a72cdbb-8870-4148-92ed-ceb4f739e2d1)

---

## Projektbeschreibung

Dieses Projekt zeigt eine vollständige CI/CD-Umgebung mit automatisiertem Build, Containerisierung und Deployment über Jenkins und Kubernetes. Es besteht aus einem Java-basierten Backend und einem statisch gebauten Frontend.

Die Herausforderung: Alles muss automatisiert, stabil und zwischen Entwicklungs- und Produktivumgebung sauber getrennt sein.

---

## Projektstruktur
bash-firma-kukuk/ ├── backend/ │ ├── Dockerfile │ └── target/backend-*.jar ├── frontend/ │ ├── Dockerfile │ └── dist/ ├── k8s/ │ ├── dev/ │ └── prod/ ├── Jenkinsfile ├── programme-installation-firma-kukuk.sh └── README.md
--

## Funktionen

- Automatisierter Build mit Maven und npm
- Docker-Container für Backend und Frontend
- Push zu Docker Hub mit Zugangsdaten
- Deployment in Kubernetes (Dev & Prod)
- Manuelle Bestätigung für Produktions-Deployments
- Bereinigungsskripte für Live-Demos

---

## Voraussetzungen

- Docker Desktop mit aktiviertem Kubernetes
- Jenkins (lokal oder remote)
- GitHub Repository mit Zugriffstoken
- Docker Hub Zugangsdaten (`DOCKER_USER`, `DOCKER_PASS`)
- Optional: kubeconfig für manuelles `kubectl`-Testing

---

## CI/CD Ablauf (Jenkins)

1. **Code holen**  
   → `checkout scm` aus GitHub

2. **Backend bauen**  
   → `mvn clean package -Pdev -DskipTests`

3. **Frontend bauen**  
   → `npm install && npm run build`

4. **Docker Build & Push**  
   → Images werden erstellt und zu Docker Hub hochgeladen  
   → Backend: `docker.io/andziallas/backend-kukuk:latest`  
   → Frontend: `docker.io/andziallas/kukuk-frontend:latest`

5. **Deployment Dev**  
   → `kubectl apply -f k8s/dev/`

6. **Deployment Prod (manuell)**  
   → Jenkins wartet auf „Ja“-Klick → `kubectl apply -f k8s/prod/`

---

## Externer Zugang (Demo)

Für externe Prüfer ist Jenkins über einen Tunnel erreichbar:

- URL: `https://andrea.pinggy.io`
- Benutzer: `dozent`
- Passwort: `jenkins123`

---

## Bereinigung für Live-Demo

```bash
# Container stoppen und löschen
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)

# Images entfernen
docker rmi andziallas/backend-kukuk:latest
docker rmi andziallas/kukuk-frontend:latest

# Kubernetes zurücksetzen
kubectl delete -f k8s/dev/


