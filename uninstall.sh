#!/bin/bash -e

pihole_latest=$(curl -s https://api.github.com/repos/arevindh/pi-hole/releases/latest | grep tag_name | cut -d '"' -f 4)
adminlte_latest=$(curl -s https://api.github.com/repos/arevindh/AdminLTE/releases/latest | grep tag_name | cut -d '"' -f 4)
pihole_ftl_latest=$(curl -s https://api.github.com/repos/pi-hole/FTL/releases/latest | grep tag_name | cut -d '"' -f 4)

pihole_current=$(pihole -v | grep "Pi-hole" | cut -d ' ' -f 3)
adminlte_current=$(pihole -v | grep "AdminLTE" | cut -d ' ' -f 6)
pihole_ftl_current=$(pihole -v | grep "FTL" | cut -d ' ' -f 6)

if [[ ! "$pihole_current" < "$pihole_latest" ]] && [[ ! "$adminlte_current" < "$adminlte_latest" ]] && [[ ! "$pihole_ftl_current" < "$pihole_ftl_latest" ]] && [[ "$1" != "un" ]]; then
    echo "Pi-hole is already up to date"
    exit 0
fi

curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/uninstall.sh | sudo bash -s -- d
PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up

if [ "$1" == "un" ]; then
    exit 0
fi

echo "Updating Speedtest Mod..."

cd /var/www/html
git clone https://github.com/arevindh/AdminLTE new_admin
cd /opt/pihole/
wget -O webpage.sh.mod https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/webpage.sh
wget -O version.sh.mod https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/version.sh
chmod +x webpage.sh.mod
chmod +x version.sh.mod
cp webpage.sh webpage.sh.org
cp version.sh version.sh.org
mv webpage.sh.mod webpage.sh
mv version.sh.mod version.sh
cd -
rm -rf pihole_admin
rm -rf admin_bak
rm -rf org_admin
mv admin org_admin
mv new_admin admin

pihole updatechecker local

echo "Update complete"