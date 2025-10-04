# Abschlussprojekt – Bash-Firma Kukuk

Dieses Projekt demonstriert eine vollständige CI/CD-Pipeline für eine Microservice-Applikation mit Spring Boot Backend und statischem Frontend.  
Alle Komponenten sind lokal ausführbar, Docker-basiert und über Jenkins automatisiert deploybar in getrennte Kubernetes-Namespaces (`dev` und `prod`).

---

## Projektstruktur

/backend → Spring Boot REST API /frontend → Statisches HTML/JS (kein Framework) /k8s/dev/ → Kubernetes-YAMLs für Dev-Umgebung /k8s/prod/ → Kubernetes-YAMLs für Prod-Umgebung /Jenkinsfile → CI/CD-Pipeline /docs/ → Screenshots und Präsentationsmaterial

Code

---

## Maven-Profilsteuerung

Die Umgebungssteuerung erfolgt über `application.properties` und Maven-Profile:

```xml
<profiles>
  <profile>
    <id>dev</id>
    <properties>
      <spring.profiles.active>dev</spring.profiles.active>
    </properties>
  </profile>
  <profile>
    <id>prod</id>
    <properties>
      <spring.profiles.active>prod</spring.profiles.active>
    </properties>
  </profile>
</profiles>
Unterschiede:
application-dev.properties: server.port=8081 → paralleles Testen möglich

application-prod.properties: logging.level.root=ERROR → reduzierte Log-Ausgabe

CI/CD mit Jenkins
Die Pipeline ist vollständig in der Jenkinsfile definiert und umfasst:

Build Backend: mvn clean package -Pprod -DskipTests

Prepare Frontend: Kein Build nötig, statisches HTML wird direkt verwendet

Docker Build & Push: Images für Backend und Frontend werden gebaut und in die Registry docker.io/andziallas gepusht

Deploy to Dev: kubectl apply -f k8s/dev/

Manual Approval: Manuelle Freigabe für Prod-Deployment

Deploy to Prod: kubectl apply -f k8s/prod/

Kubernetes-YAMLs
Backend
k8s/dev/deployment-backend-dev.yaml

k8s/dev/service-backend-dev.yaml

k8s/prod/deployment-backend-prod.yaml

k8s/prod/service-backend-prod.yaml

Frontend
k8s/dev/frontend-deployment.yaml

k8s/dev/frontend-service.yaml

k8s/prod/frontend-deployment.yaml

k8s/prod/frontend-service.yaml

→ Alle Deployments nutzen die Images aus docker.io/andziallas

Hinweise zur Jenkins-Konfiguration
Zugang zur Docker Registry über dockerlogin (Credentials in Jenkins)

Zugang zum Kubernetes-Cluster über kubeconfig-creds (Datei-Credential)

Jenkins läuft lokal auf http://localhost:8080

Benutzer andziallas, Passwort admin123 manuell gesetzt über config.xml

Frontend-Hinweis
Das Frontend ist bewusst statisch gehalten. Es wurde kein Framework wie Angular verwendet, um die Demo schlank und ressourcenschonend zu halten. Ein Build-Prozess (npm install, ng build) ist nicht erforderlich.

Präsentation
Live-Demo oder Screenshots am 29.09.2025

Screenshots liegen unter /docs/screenshots/

Alternativ: API-Response via curl http://localhost:8080/

Lizenz / Nutzung
Dieses Projekt dient ausschließlich zu Demonstrationszwecken. Keine produktive Nutzung ohne Sicherheitsprüfung. Alle Zugangsdaten und Konfigurationen wurden lokal getestet und dokumentiert.