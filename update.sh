#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

sudo apt update
sudo apt install jq -y

whiptail --title "Pi-hole Speedtest Mod Updater" --msgbox "Pi-hole Speedtest Mod Updater. \nSupport : https://github.com/arevindh/pihole-speedtest " 8 78
if (whiptail --title "Pi-hole Speedtest Mod Updater" --yesno "Proceed to update ?" 8 78); then
    echo "Proceeding with update"
else
    exit 1
fi

echo "Reverting files..."
cd /var/www/html
# if org_admin exists, mv it to admin, else clone admin from URL
if [ -d /var/www/html/org_admin ]; then
    rm -rf admin
    mv org_admin admin
else
    rm -rf admin
    git clone https://github.com/pi-hole/AdminLTE admin
fi

cd /opt/pihole/
if [ -f /opt/pihole/webpage.sh.org ]; then
    mv webpage.sh.org webpage.sh
else
    wget https://github.com/pi-hole/pi-hole/raw/master/advanced/Scripts/webpage.sh
    chmod +x webpage.sh
fi
if [ -f /opt/pihole/version.sh.org ]; then
    mv version.sh.org version.sh
else
    wget https://github.com/pi-hole/pi-hole/raw/master/advanced/Scripts/version.sh
    chmod +x version.sh
fi
echo "Files reverted."

pihole -up

if [ -n "$1" ] && [ "$1" = "un" ]; then
    echo "Speedtest Mod Uninstall Complete"
    exit 0
fi

echo "Updating Speedtest Mod..."
cd /var/www/html
rm -rf pihole_admin
rm -rf admin_bak
rm -rf org_admin
mv admin org_admin
git clone https://github.com/arevindh/AdminLTE admin

#Update latest webpage.sh for speedtest-mod
cd /opt/pihole/
mv webpage.sh webpage.sh.org
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh

mv version.sh version.sh.org
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/version.sh
chmod +x version.sh

#Update version info
pihole updatechecker local

whiptail --title "Pihole Speedtest Mod" --msgbox "Update complete" 8 78
exit 0