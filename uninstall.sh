#!/bin/bash

if [ -n "$1" ] && [ "$1" = "up" ]; then
    curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/update.sh | bash -s un
    exit 0
fi

# if org_admin, webpage.sh.org and version.sh.org exist, then we can uninstall
if [ ! -d /var/www/html/org_admin ] || [ ! -f /opt/pihole/webpage.sh.org ] || [ ! -f /opt/pihole/version.sh.org ]; then
    echo "Cannot uninstall. Please run \"uninstall.sh up\"."
    exit 1
fi

echo "Reverting files..."
sudo su
cd /var/www/html
rm -rf admin
mv org_admin admin
cd /opt/pihole/
mv webpage.sh.org webpage.sh
mv version.sh.org version.sh
echo "Done."

exit 0