#!/usr/bin/env bash
# Tonie Management einrichten bzw. aktualisieren (Linux/macOS mit Docker, z. B. Raspberry Pi oder NAS).
# Erneut ausführen ist gefahrlos: Zugangsdaten (.env) und Pläne (data/) bleiben erhalten.
set -euo pipefail
cd "$(dirname "$0")"

DOCKER="docker"
if ! docker info >/dev/null 2>&1; then
  if sudo -n docker info >/dev/null 2>&1 || sudo docker info >/dev/null 2>&1; then DOCKER="sudo docker"
  else echo "FEHLER: Docker läuft nicht oder ist nicht installiert (https://docs.docker.com/get-docker/)."; exit 1; fi
fi
$DOCKER compose version >/dev/null 2>&1 || { echo "FEHLER: „docker compose“ fehlt (Docker Compose v2)."; exit 1; }

echo "=== Tonie Management einrichten ==="

# 1) Einstellungen (nur beim ersten Mal) – bleiben nur auf diesem Rechner in .env
if [ ! -f .env ]; then
  echo "Zugangsdaten deines tonies-Kontos (my.tonies.com). Sie werden nur lokal in $(pwd)/.env gespeichert."
  read -rp  "E-Mail:   " TU
  read -rsp "Passwort: " TP; echo
  read -rp  "Ordner für die Hörspiele [$(pwd)/hoerspiele]: " HO
  read -rp  "Standard-Uhrzeit fürs Bespielen [17:30]: " UZ
  HO="${HO:-$(pwd)/hoerspiele}"
  umask 077
  cat > .env <<EOF
TONIES_USER=$TU
TONIES_PASS=$TP
HOERSPIEL_ORDNER=$HO
UHRZEIT=${UZ:-17:30}
MODUS=reihenfolge
PORT=8095
TZ=Europe/Berlin
EOF
  chmod 600 .env
  echo "✓ Einstellungen gespeichert in .env (ändern: Datei bearbeiten, dann ./install.sh erneut ausführen)"
fi

HO=$(sed -n 's/^HOERSPIEL_ORDNER=//p' .env | tail -1); HO="${HO:-./hoerspiele}"
PORT=$(sed -n 's/^PORT=//p' .env | tail -1); PORT="${PORT:-8095}"
mkdir -p "$HO" data

# 2) Container bauen und starten
$DOCKER compose build -q
$DOCKER compose up -d
sleep 3

# 3) Je Kreativ-Tonie einen Ordner anlegen (wird automatisch zugeordnet, Automatik bleibt aus)
echo
echo "Kreativ-Tonies in deinem Konto:"
if NAMEN=$($DOCKER exec tonie-management python3 tonie_management.py --tonies 2>/dev/null); then
  echo "$NAMEN"
  while IFS= read -r zeile; do
    n=$(printf '%s' "$zeile" | sed 's/^ • //; s#[/:]#-#g; s/^ *//; s/ *$//')
    [ -n "$n" ] || continue
    [ -d "$HO/$n" ] || { mkdir -p "$HO/$n" && echo "  ✓ Ordner angelegt: $HO/$n"; }
  done <<< "$NAMEN"
  $DOCKER restart tonie-management >/dev/null
else
  echo "  (Anmeldung fehlgeschlagen – Zugangsdaten in .env prüfen, dann ./install.sh erneut ausführen)"
fi

IP=$( (hostname -I 2>/dev/null || ipconfig getifaddr en0 2>/dev/null || echo localhost) | awk '{print $1}')
echo
echo "✓ Tonie Management läuft:  http://$IP:$PORT"
echo "  Hörspiele:          $HO/<Name des Tonies>/   (eine Datei = eine Folge, ein Unterordner = eine Folge mit Kapiteln)"
echo "  Automatik je Tonie in der Weboberfläche einschalten."
echo
echo "  Pläne & Inhalt:   $DOCKER exec tonie-management python3 tonie_management.py --liste"
echo "  Sofort bespielen: $DOCKER exec tonie-management python3 tonie_management.py --jetzt NAME"
echo "  Protokoll:        $DOCKER logs -f tonie-management"
