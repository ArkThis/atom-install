#!/bin/bash
#@author: Peter B. (p.bubestinger@ArkThis.com)
#@date: 2025-09-17
#Instructions based on:
#https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/upgrading/

#@description:
#Takes care of running the database-contents update script.

MYDIR=$(dirname "$0")            # path of this script. Must be here, to find config.
source "$MYDIR/../config.sh"     # Load variables/functions

PWD=$(pwd)
cd $DIR_ATOM_SITE

log "Running update-script on '$DIR_ATOM_SITE'..."
# --------------------------
$BECOME_WEB php -d memory_limit=-1 symfony tools:upgrade-sql

echo "If this went well: CELEBRATE! 🌻️ 🎉️"
pause


# OPTIONAL:
log "Login-hack to access foreign AtoM DB exports..."
# --------------------------

# DO NOT use double-quotes here: it'll try to resolve $argon and $v:
HASH='$argon2i$v=19$m=65536,t=4,p=1$b3JBR1ZxVkNkNkw3LzlUWA$8E1IKSwwpYuxASOQxGEiE9ZX+48hZCCg+CVD5l7/KpQ'
SALT='6e648b2bad8fa5f4e22e539003badb6c'
$MYSQL -p atom -e "UPDATE user SET password_hash='$HASH', salt='$SALT' WHERE username='atomadmin';"
echo "Done ($?)"


./upgrade-atom-search.sh
