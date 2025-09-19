#!/bin/bash
#@author: Peter B. (p.bubestinger@ArkThis.com)
#@date: 2025-09-17
#Instructions based on:
#https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/upgrading/

#@description:
#Takes care of running the database-contents update script.

PWD=$(pwd)
cd $DIR_ATOM_SITE

log "Running update-script on '$DIR_ATOM_SITE'..."
sudo -u $WEBSITE_USER php -d memory_limit=-1 symfony tools:upgrade-sql
pause
