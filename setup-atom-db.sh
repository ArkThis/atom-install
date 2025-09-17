#!/bin/bash
#@description:
# Creates and sets up the MySQL database for AtoM (v2.9)
# According to documentation:
# https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/ubuntu/#installation-ubuntu

THIS_ATOM="atom"
ATOM_USER="atom"
ATOM_PW="aTOmPASSword25"


# --------------------
echo ""
echo "Setting up database '$THIS_ATOM' for user '$ATOM_USER'..."
echo ""
# --------------------

function run
{
    CMD="$1"
    echo "$CMD"
    eval "$CMD"
}

CMD="sudo mysql -h localhost -u root -e \"CREATE DATABASE $THIS_ATOM CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;\""
run "$CMD"

CMD="sudo mysql -h localhost -u root -e \"CREATE USER '$ATOM_USER'@'localhost' IDENTIFIED BY '$ATOM_PW';\""
run "$CMD"

CMD="sudo mysql -h localhost -u root -e \"GRANT ALL PRIVILEGES ON $THIS_ATOM.* TO '$ATOM_USER'@'localhost';\""
run "$CMD"
