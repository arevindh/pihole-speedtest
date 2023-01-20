#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

sudo apt update
sudo apt install jq -y

whiptail --title "Pihole Speedtest Mod Updater" --msgbox "Pihole Speedtest Mod Updater. \nSupport : https://github.com/arevindh/pihole-speedtest " 8 78
if (whiptail --title "Pihole Speedtest Mod Updater" --yesno "Proceed to update ?" 8 78); then
    echo "Proceeding with update"
else
    exit 1;
fi

echo "Updating Pihole and Speedtest-mod"

#Revert admin to Pihole's newest
cd /var/www/html
rm -rf admin/
git clone https://github.com/pi-hole/AdminLTE admin

#Revert pihole's webpage
cd /opt/pihole/
rm webpage.sh
wget https://github.com/pi-hole/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh

#Update Pihole
pihole -up

#Update lastest speedtest-mod
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
wget https://raw.githubusercontent.com/arevindh/pi-hole/master/advanced/Scripts/version.sh
chmod +x version.sh

#Update version info
pihole updatechecker local


whiptail --title "Pihole Speedtest Mod" --msgbox "Update complete" 8 78
exit 0