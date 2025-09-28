#!/bin/bash

set -e
set -o pipefail

echo "🔧 Starte Installation unter WSL..."

# === Prüfen ob WSL aktiv ist ===
if grep -qi microsoft /proc/version; then
  echo "[OK] WSL erkannt: $(uname -r)"
else
  echo "[ERROR] Dieses Skript ist nur für WSL vorgesehen."
  exit 1
fi

# === Abhängigkeiten definieren ===
DEPENDENCIES=("java" "mvn" "node" "npm" "kubectl" "jenkins" "ng")

# === Version anzeigen ===
print_version() {
  local cmd=$1
  echo "[INFO] $cmd Version: $($cmd --version 2>/dev/null || echo 'Keine Versionsinfo verfügbar')"
}

# === Installation je nach Tool ===
check_and_install() {
  local cmd=$1
  case "$cmd" in
    java)
      sudo apt update && sudo apt install -y openjdk-17-jdk
      ;;
    mvn)
      sudo apt update && sudo apt install -y maven
      ;;
    node)
      curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
      sudo apt install -y nodejs
      ;;
    npm)
      # npm kommt mit node.js
      ;;
    ng)
      sudo npm install -g @angular/cli
      ;;
    kubectl)
      curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      ;;
    jenkins)
      curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
        /usr/share/keyrings/jenkins-keyring.asc > /dev/null
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      sudo apt update && sudo apt install -y jenkins
      ;;
    *)
      echo "[WARN] Keine Routine für $cmd definiert."
      ;;
  esac
  print_version "$cmd"
}

# === Hauptlogik ===
for dep in "${DEPENDENCIES[@]}"; do
  if ! command -v "$dep" &> /dev/null; then
    echo "[INFO] $dep nicht gefunden. Installation wird gestartet..."
    check_and_install "$dep"
  else
    echo "[OK] $dep ist bereits installiert."
    print_version "$dep"
  fi
done

echo "✅ Alle Programme sind unter WSL installiert oder aktualisiert."
