#!/bin/bash

echo "Get original admin codebase from git"
sudo su
cd /var/www/html
mv admin org_admin
git clone https://github.com/pi-hole/AdminLTE admin
rm -rf org_admin

echo "Get original webpage.sh file from git"
cd /opt/pihole/
rm webpage.sh
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh

echo "Get original version.sh file from git"
rm version.sh
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x version.sh

# run this script with "up" as argument to update pihole
if [ -n "$1" ] && [ "$1" = "up" ]; then
    echo "Running pihole -up"
    pihole -up
fi

exit 0