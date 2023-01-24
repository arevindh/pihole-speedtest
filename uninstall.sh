#!/bin/bash -e

echo "$(date) - Uninstalling Speedtest Mod..."

cd /opt/
if [ ! -f /opt/pihole/webpage.sh.org ]; then
    rm -rf org_pihole
    git clone https://github.com/pi-hole/pi-hole org_pihole
    cd org_pihole
    currVer=$(pihole -v | grep "Pi-hole" | cut -d ' ' -f 3)
    git checkout $currVer >/dev/null 2>&1
    chmod +x advanced/Scripts/webpage.sh
    cp advanced/Scripts/webpage.sh ../pihole/webpage.sh.org
    cd -
    rm -rf org_pihole
fi

cd /var/www/html
if [ ! -d /var/www/html/org_admin ]; then
    rm -rf org_admin
    git clone https://github.com/pi-hole/AdminLTE org_admin
    cd org_admin
    git fetch --tags
    currVer=$(pihole -v | grep "AdminLTE" | cut -d ' ' -f 6)
    git checkout $currVer >/dev/null 2>&1
    cd -
fi

if [ "$1" == "db" ]; then
	echo "$(date) - Clearing history..."
	if [ -f /etc/pihole/speedtest.db ]; then
		mv /etc/pihole/speedtest.db speedtest.db.old
	fi
    cp scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
fi

echo "$(date) - Restoring Pi-hole..."

if [ -d /var/www/html/admin ]; then
    rm -rf mod_admin
    mv admin mod_admin
fi
mv org_admin admin
cd /opt/pihole/
cp webpage.sh webpage.sh.mod
mv webpage.sh.org webpage.sh

echo "$(date) - Uninstall complete"