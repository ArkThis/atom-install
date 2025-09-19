#!/bin/bash
#@author: Peter B. (p.bubestinger@ArkThis.com)
#@date: 2025-09-17
#Instructions based on:
#https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/upgrading/

#@description:
#Takes care of refreshing the search and browse indexes and services:

MYDIR=$(dirname "$0")            # path of this script. Must be here, to find config.
source "$MYDIR/../config.sh"     # Load variables/functions

PWD=$(pwd)
cd $DIR_ATOM_SITE                # The "BECOME_WEB" calls must be run in atom's website folder.


log "Regenerating derivative copies of media files..."
# --------------------------
$BECOME_WEB php symfony digitalobject:regen-derivatives
pause

log "Rebuilding search index and clear cache..."
# --------------------------
$BECOME_WEB php -d memory_limit=-1 symfony search:populate
pause

log "Clearing possible outdated cache..."
# --------------------------
$BECOME_WEB php symfony cc
pause



SERVICES="$PHPFPM memcached atom-worker"
log "Restarting services: $SERVICES..."
# --------------------------

for SERVICE in $SERVICES; do
    continue # Enable to DEBUG lower parts of the script.

    sudo systemctl restart $SERVICE
    sudo systemctl status $SERVICE
    pause
done


