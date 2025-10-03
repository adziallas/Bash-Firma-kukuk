#!/bin/bash

set -e

echo "🧹 Entferne temporäre Verzeichnisse..."

rm -rf .trunk/ node_modules/ frontend/node_modules/ backend/target/

echo "✅ Temporäre Ordner gelöscht"

echo "📦 Aktualisiere .gitignore..."

cat <<EOF >> .gitignore

# Temporäre Ordner
.trunk/
node_modules/
frontend/node_modules/
backend/target/
EOF

echo "✅ .gitignore aktualisiert"

echo "🧼 Entferne ignorierte Dateien aus Git-Index..."

git rm -r --cached .trunk/ node_modules/ frontend/node_modules/ backend/target/ || true

echo "✅ Git-Index bereinigt"

echo "📋 Status nach Cleanup:"
git status

echo "✅ Cleanup abgeschlossen"
