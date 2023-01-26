#!/bin/bash -e

set -e

echo "$(date) - Restoring Pi-hole..."

cd /opt/
if [ ! -f /opt/pihole/webpage.sh.org ]; then
    echo "$(date) - Downloading Pi-hole..."
    rm -rf org_pihole
    git clone https://github.com/pi-hole/pi-hole org_pihole
    cd org_pihole
    git fetch --tags -q
    localVer=$(pihole -v | grep "Pi-hole" | cut -d ' ' -f 3)
    remoteVer=$(curl -s https://api.github.com/repos/pi-hole/pi-hole/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    if [ $(echo "$localVer > $remoteVer" | bc) -eq 1 ]; then
        remoteVer=$localVer
    fi
    git checkout $remoteVer
    cp advanced/Scripts/webpage.sh ../pihole/webpage.sh.org
    cd -
    rm -rf org_pihole
fi

cd /var/www/html
if [ ! -d /var/www/html/org_admin ]; then
    echo "$(date) - Downloading AdminLTE..."
    rm -rf org_admin
    git clone https://github.com/pi-hole/AdminLTE org_admin
    cd org_admin
    git fetch --tags -q
    git reset --hard origin/master
    localVer=$(pihole -v | grep "AdminLTE" | cut -d ' ' -f 6)
    remoteVer=$(curl -s https://api.github.com/repos/pi-hole/AdminLTE/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    if [ $(echo "$localVer > $remoteVer" | bc) -eq 1 ]; then
        remoteVer=$localVer
    fi
    git checkout $remoteVer
    cd -
fi

if [ "$1" == "db" ]; then
	echo "$(date) - Clearing History..."
	if [ -f /etc/pihole/speedtest.db ]; then
		mv /etc/pihole/speedtest.db /etc/pihole/speedtest.db.old
	fi
    cp scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
fi

echo "$(date) - Uninstalling Current Speedtest Mod..."

if [ -d /var/www/html/admin ]; then
    rm -rf mod_admin
    mv admin mod_admin
fi
mv org_admin admin
cd /opt/pihole/
cp webpage.sh webpage.sh.mod
mv webpage.sh.org webpage.sh
chmod +x webpage.sh

echo "$(date) - Uninstall Complete"
