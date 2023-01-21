#!/bin/bash

echo "This script is work in progress; please use the install instructions here: https://github.com/arevindh/pihole-speedtest/wiki/Installing-Speedtest-Mod"
exit

#command -v pihole >/dev/null 2>&1 || { whiptail --title "Install Failed" --msgbox  "No pihole install found. Aborting install"  8 78 >&2; exit;}

# make sure we are root
if [ $EUID != 0 ]; then
	sudo "$0" "$@"
	exit $?
fi

# if pihole is not installed, install it
if [ ! -f /usr/local/bin/pihole ]; then
	echo "Pihole not found. Installing pihole"
	curl -sSL https://install.pi-hole.net | bash
fi

whiptail --title "Pihole Speedtest Mod" --msgbox "Pihole Speedtest Mod installer." 8 78
if php -v | grep 'PHP 7' > /dev/null ; then 
	sudo apt install php7.0-sqlite
else
	whiptail --title "Pihole Speedtest Mod" --msgbox "PHP 5.x found. Installing php5-sqlite" 8 78
	sudo apt install php5-sqlite
fi 
PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3)

whiptail --title "Pihole Speedtest Mod" --msgbox "PHP $PHP_VERSION found. Installing $PHP_VERSION-sqlite3 " 8 78
sudo apt install $PHP_VERSION-sqlite3

whiptail --title "Pihole Speedtest Mod" --msgbox "Instaling requiered pakages python-pip,speedtest-cli,sqlite3" 8 78
sudo apt-get install -y gnupg1 apt-transport-https dirmngr &> /dev/null
export INSTALL_KEY=379CE192D401AB61 &> /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY &> /dev/null
echo "deb https://ookla.bintray.com/debian generic main" | sudo tee  /etc/apt/sources.list.d/speedtest.list &> /dev/null
sudo apt-get update &> /dev/null
sudo apt-get install -y speedtest &> /dev/null
sudo apt install -y sqlite3 &> /dev/null
sudo apt install -y jq &> /dev/null

whiptail --title "Pihole Speedtest Mod" --msgbox "Please set your timezone once prompted" 8 78
sudo dpkg-reconfigure tzdata  

whiptail --title "Pihole Speedtest Mod" --msgbox "Get latest pakage from github" 8 78
sudo su
cd /var/www/html
rm -rf org_admin
mv admin org_admin
git clone https://github.com/arevindh/AdminLTE admin
cd admin

if [ ! -f /etc/pihole/speedtest.db ]; then
	whiptail --title "Pihole Speedtest Mod" --msgbox "Initializing database" 8 78
	#Create new DB in /etc/pihole/
	cp scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
fi

whiptail --title "Pihole Speedtest Mod" --msgbox "Updating webpage.sh" 8 78

cd /opt/pihole/
mv webpage.sh webpage.sh.org
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/webpage.sh
chmod +x webpage.sh

mv version.sh version.sh.org
wget https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/version.sh
chmod +x version.sh

#Update version info
pihole updatechecker local

whiptail --title "Pihole Speedtest Mod" --msgbox "Install complete" 8 78
exit 0
