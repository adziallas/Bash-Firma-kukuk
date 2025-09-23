#!/bin/bash

echo "🔧 Starte automatisierten Build & Deployment für Kukuk Backend..."

# Schritt 1: In das Backend-Verzeichnis wechseln
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR/backend" || { echo "❌ Verzeichnis 'backend' nicht gefunden!"; exit 1; }

# Schritt 2: Dev-Build
echo "📦 Baue Dev-Profil mit Maven..."
mvn clean package -Pdev -DskipTests
if [ $? -ne 0 ]; then
  echo "❌ Dev-Build fehlgeschlagen!"
  exit 1
fi
echo "✅ Dev-Build erfolgreich."

# Schritt 3: Prod-Build
echo "📦 Baue Prod-Profil mit Maven..."
mvn clean package -Pprod -DskipTests
if [ $? -ne 0 ]; then
  echo "❌ Prod-Build fehlgeschlagen!"
  exit 1
fi
echo "✅ Prod-Build erfolgreich."

# Schritt 4: Docker-Image bauen
echo "🐳 Erstelle Docker-Image..."
docker build -t kukuk-backend .

# Schritt 5: Alte Container entfernen
echo "🧹 Entferne alte Container (falls vorhanden)..."
docker rm -f kukuk-dev 2>/dev/null
docker rm -f kukuk-prod 2>/dev/null

# Schritt 6: Dev-Container starten
echo "🚀 Starte Dev-Container auf Port 8081..."
docker run -d -p 8081:8081 \
  -e SPRING_PROFILES_ACTIVE=dev \
  --name kukuk-dev \
  kukuk-backend

# Schritt 7: Prod-Container starten
echo "🚀 Starte Prod-Container auf Port 8080..."
docker run -d -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  --name kukuk-prod \
  kukuk-backend

# Schritt 8: Ausgabe
echo "🌐 Backend läuft jetzt unter:"
echo "→ Dev:  http://localhost:8081"
echo "→ Prod: http://localhost:8080"
echo "📨 Antwort: 'Willkommen im Kukuk Backend'"
