#!/bin/bash

# Clear the terminal screen at the beginning
clear

# Define color codes
RED='\033[0;31m'        # Red for errors
YELLOW='\033[0;33m'     # Yellow for informational messages
GREEN='\033[0;32m'      # Green for success
NC='\033[0m'            # No color (reset)

# Detect the system language (default language is the LC_MESSAGES part of the locale)
system_language=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1)

# Show menu on detected system language or default to english
if [[ "$system_language" == "es" ]]; then
  LANGUAGE_PROMPT="Por favor, seleccione su idioma"
  ENGLISH_LANG="Ingles"
  SPANISH_LANG="Español"
  INPUT_PROMPT="Ingrese el numero de su opcion"
else
  LANGUAGE_PROMPT="Please select your language"
  ENGLISH_LANG="English"
  SPANISH_LANG="Spanish"
  INPUT_PROMPT="Enter the number of your choice"
fi

echo -e "$LANGUAGE_PROMPT:"
echo -e "1) $ENGLISH_LANG"
echo -e "2) $SPANISH_LANG"
read -p "$INPUT_PROMPT: " language_choice

# Set language messages based on user input
if [[ "$language_choice" == "2" || "$language_choice" == "es" ]]; then
  # Spanish messages
  INSTALL_MSG="${YELLOW}Instalando apt-transport-https y curl..."
  CREATE_KEYRINGS_MSG="${YELLOW}Creando el directorio /etc/apt/keyrings..."
  DOWNLOAD_KEYRING_MSG="${YELLOW}Descargando la clave de firma de MariaDB..."
  CREATE_SOURCES_FILE_MSG="${YELLOW}Creando el archivo /etc/apt/sources.list.d/mariadb.sources..."
  UPDATE_MSG="${YELLOW}Ejecutando sudo apt-get update..."
  MARIADB_INSTALLED_MSG="${YELLOW}El servidor MariaDB ya está instalado. Ejecutando sudo apt-get upgrade..."
  INSTALL_MARIADB_MSG="${YELLOW}Instalando el servidor MariaDB..."
  SETUP_COMPLETE_MSG="${GREEN}Configuración completada."
  UPGRADE_COMPLETE_MSG="${GREEN}Actualización completada."
  UPGRADE_FAILED_MSG="${RED}La actualización falló o fue interrumpida."
else
  # Default to English messages
  INSTALL_MSG="${YELLOW}Installing apt-transport-https and curl..."
  CREATE_KEYRINGS_MSG="${YELLOW}Creating /etc/apt/keyrings directory..."
  DOWNLOAD_KEYRING_MSG="${YELLOW}Downloading MariaDB release signing key..."
  CREATE_SOURCES_FILE_MSG="${YELLOW}Creating /etc/apt/sources.list.d/mariadb.sources file..."
  UPDATE_MSG="${YELLOW}Running sudo apt-get update..."
  MARIADB_INSTALLED_MSG="${YELLOW}MariaDB server is already installed. Running sudo apt-get upgrade..."
  INSTALL_MARIADB_MSG="${YELLOW}Installing MariaDB server..."
  SETUP_COMPLETE_MSG="${GREEN}Setup complete."
  UPGRADE_COMPLETE_MSG="${GREEN}Upgrade complete."
  UPGRADE_FAILED_MSG="${RED}Upgrade failed or was interrupted."
fi

# Update and install necessary packages
echo -e "$INSTALL_MSG"
sudo apt-get install -y apt-transport-https curl

# Create the directory for keyrings
echo -e "$CREATE_KEYRINGS_MSG"
sudo mkdir -p /etc/apt/keyrings

# Download the MariaDB keyring
echo -e "$DOWNLOAD_KEYRING_MSG"
sudo curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

# Create the /etc/apt/sources.list.d/mariadb.sources file
echo -e "$CREATE_SOURCES_FILE_MSG"

# Writing the provided content into the file
sudo bash -c 'cat > /etc/apt/sources.list.d/mariadb.sources <<EOF
# MariaDB 11.4 repository list - created 2025-03-05 00:02 UTC
# https://mariadb.org/download/
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# URIs: https://deb.mariadb.org/11.4/debian
URIs: https://mirror.insacom.cl/mariadb/repo/11.4/debian
Suites: bookworm
Components: main
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
EOF'

# Update the package list
echo -e "$UPDATE_MSG"
sudo apt-get update

# Check if mariadb-server is already installed
if dpkg -l | grep -q mariadb-server; then
  echo -e "$MARIADB_INSTALLED_MSG"
  # Suppress the output of apt-get upgrade and only show a custom message for mariadb-server
  sudo apt-get upgrade -y mariadb-server > /dev/null 2>&1

  # Check if the upgrade completed successfully
  if [[ $? -eq 0 ]]; then
    echo -e "$UPGRADE_COMPLETE_MSG"
  else
    echo -e "$UPGRADE_FAILED_MSG"
  fi
else
  # Install MariaDB server if it's not installed
  echo -e "$INSTALL_MARIADB_MSG"
  sudo apt-get install -y mariadb-server
fi

echo -e "$SETUP_COMPLETE_MSG"

echo -e "${NC}"
