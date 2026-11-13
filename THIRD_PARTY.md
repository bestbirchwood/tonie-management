# Verwendete Software / Third-party software

Tonie Management selbst steht unter der MIT-Lizenz (siehe `LICENSE`). Es enthält **keinen** fremden Code;
die folgenden Bibliotheken werden beim Bauen des Docker-Images aus dem Python Package Index (PyPI)
geladen und behalten ihre eigenen Lizenzen.

| Software | Wofür | Lizenz | Quelle |
|---|---|---|---|
| **tonie-api** (Willi Meierhof / Wilhelmsson177) | Anmeldung bei der tonies-Cloud, Kreativ-Tonies auflisten, Kapitel löschen und hochladen | MIT | https://github.com/Wilhelmsson177/tonie-api · https://pypi.org/project/tonie-api/ |
| **mutagen** (quodlibet-Projekt) | Laufzeit der Audiodateien lesen (für den 90-Minuten-Check und die Anzeige) | GPL-2.0-or-later | https://github.com/quodlibet/mutagen · https://pypi.org/project/mutagen/ |
| **Python 3.12** inkl. Standardbibliothek (`http.server`, `json`, `threading` …) | Laufzeitumgebung, Weboberfläche | PSF License | https://www.python.org |
| **python:3.12-slim** (Docker Official Image) | Basis-Image des Containers | verschiedene (Debian, PSF) | https://hub.docker.com/_/python |

`tonie-api` bringt beim Installieren eigene Abhängigkeiten mit (u. a. `requests`); deren Lizenzen
stehen auf den jeweiligen PyPI-Seiten.

Hinweis zu mutagen: mutagen steht unter der GPL. Tonie Management bindet es nur zur Laufzeit ein und
verteilt es nicht mit; wer ein fertiges Docker-Image weitergibt, verteilt damit auch mutagen und
muss dessen Lizenzbedingungen beachten.

## Marken / Trademarks

„tonies“, „Toniebox“, „Tonie“ und „Kreativ-Tonie“ sind Marken der Boxine GmbH. Dieses Projekt ist
**inoffiziell** und steht in keiner Verbindung zur Boxine GmbH. Es nutzt eine inoffizielle,
nicht dokumentierte Schnittstelle, die sich jederzeit ändern kann.
