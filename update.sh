#!/bin/bash

echo "Updating Pihole and Speedtest-mod"

#Revert admin to Pihole's newest
cd /var/www/html
sudo rm -rf admin/
sudo git clone https://github.com/pi-hole/AdminLTE admin

#Rever pihole's webpage
cd /opt/pihole/
sudo rm webpage.sh
sudo wget https://github.com/pi-hole/pi-hole/raw/master/advanced/Scripts/webpage.sh
sudo chmod +x webpage.sh

#Update Pihole
pihole -up

#Update lastest speedtest-mod
cd /var/www/html
sudo mv admin admin_org
sudo git clone https://github.com/TooManyEggrolls/AdminLTE admin

#Update latest webpage.sh for speedtest-mod
cd /opt/pihole/
sudo mv webpage.sh webpage.sh.org
sudo wget https://github.com/TooManyEggrolls/pi-hole/raw/master/advanced/Scripts/webpage.sh
sudo chmod +x webpage.sh

#Update version info
pihole updatechecker local
