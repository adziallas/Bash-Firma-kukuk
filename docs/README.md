
**ANMERKUNG***
1. zu diesem Repo gehört noch ein automatisiertes bash-skript das alle benötigten Programme unter wsl installiert.
nach Projektabschluss wird die datei seperat hochgeladen.! 
___________________________________________________________________________________________________________

2. Die Jenkins-Pipelines wurde über https://localhost:9090 gestartet und getestet, da die bereitgestellte Jenkinsseite nicht verfügbar war. 

# Abschlussprojekt – DevOps Engineering bei Kukuk Technology Future GmbH

Enthalten ist hier der technische Aufbau und die Bereitstellung einer vollständigen CI/CD-Pipeline für eine neue Microservice-Applikation mit Frontend und Backend. 

Die Herausforderung: alles muss automatisiert, stabil und zwischen Entwicklungs- und Produktivumgebung sauber getrennt sein.

**DevOps Abschlussprojekt mit CI/CD, Docker und Kubernetes**

Dieses Projekt zeigt eine vollständige  mit automatisiertem Build, Containerisierung und Deployment über Jenkins und Kubernetes. Es besteht aus einem Java-basierten Backend und einem statisch gebauten Frontend.


---

## Projektstruktur
<img width="497" height="187" alt="image" src="https://github.com/user-attachments/assets/f8f5d037-a3ce-450d-bfe0-9b0322de5563" />

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

##  CI/CD Ablauf (Jenkins)

1. **Code holen**  
   → `checkout scm` aus GitHub

2. **Backend bauen**  
   → `mvn clean package -Pdev -DskipTests`

3. **Frontend bauen**  
   → `npm install && npm run build`

4. **Docker Build & Push**  
   → Images werden erstellt und zu Docker Hub hochgeladen

5. **Deployment Dev**  
   → `kubectl apply -f k8s/dev/`

6. **Deployment Prod (manuell)**  
   → Jenkins wartet auf „Yes“-Klick → `kubectl apply -f k8s/prod/`

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
____________________________________________________________________________________________________________
Hinweise
Die Jenkins-Pipeline ist so konfiguriert, dass sie nur bei Bestätigung in der Jenkinskonsole auf "Ja" klicken
wenn sie das nicht soll " Nein" anklicken.

Die Kubernetes-Konfiguration nutzt kubeadm über Docker Desktop.

Für Live-Demos empfiehlt sich ein Clean Start mit den obigen Befehlen.


Lizenzfrei
Dieses Projekt steht unter keiner speziellen Lizenz. Nutzung zu Lern- und Demonstrationszwecken erlaubt.
