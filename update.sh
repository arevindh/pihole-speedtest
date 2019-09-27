#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

whiptail --title "Pihole Speedtest Mod " --msgbox "Pihole Speedtest Mod Updater. \nSupport : https://github.com/arevindh/pihole-speedtest " 8 78

echo "Updating Pihole and Speedtest-mod"

#Revert admin to Pihole's newest
cd /var/www/html
rm -rf admin/
git clone https://github.com/pi-hole/AdminLTE admin

#Rever pihole's webpage
cd /opt/pihole/
rm webpage.sh
wget https://github.com/pi-hole/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh


#Update Pihole
pihole -up

#Update lastest speedtest-mod
cd /var/www/html
mv admin admin_org
git clone https://github.com/TooManyEggrolls/AdminLTE admin

#Update latest webpage.sh for speedtest-mod
cd /opt/pihole/
mv webpage.sh webpage.sh.org
wget https://github.com/TooManyEggrolls/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh

#Update version info
pihole updatechecker local


whiptail --title "Pihole Speedtest Mod" --msgbox "Update complete" 8 78
