#!/bin/bash
#@description:
# Creates and sets up the MySQL database for AtoM (v2.9)
# According to documentation:
# https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/ubuntu/#installation-ubuntu

source config.sh

log "Setting up database '$ATOM_DB' for user '$ATOM_DB_USER'..."
# --------------------

CMD="sudo mysql -h localhost -u root -e \"CREATE DATABASE $ATOM_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;\""
run "$CMD"

CMD="sudo mysql -h localhost -u root -e \"CREATE USER '$ATOM_DB_USER'@'localhost' IDENTIFIED BY '$ATOM_DB_PW';\""
run "$CMD"

CMD="sudo mysql -h localhost -u root -e \"GRANT ALL PRIVILEGES ON $ATOM_DB.* TO '$ATOM_DB_USER'@'localhost';\""
run "$CMD"
