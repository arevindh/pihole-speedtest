#!/bin/bash

echo "Get original admin codebase from backup"
sudo su
cd /var/www/html
rm -rf admin
mv org_admin admin

echo "Get original webpage.sh file from backup"
cd /opt/pihole/
mv webpage.sh.org webpage.sh

echo "Get original version.sh file from backup"
mv version.sh.org version.sh

# run this script with "up" as argument to update pihole
if [ -n "$1" ] && [ "$1" = "up" ]; then
    echo "Running pihole -up"
    pihole -up
fi

exit 0