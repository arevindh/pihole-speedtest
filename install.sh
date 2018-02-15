#!/bin/bash

command -v pihole >/dev/null 2>&1 || { whiptail --title "Install Failed" --msgbox  "No pihole install found. Aborting install"  8 78 >&2; exit;}

#if (( $EUID != 0 )); then
#    echo "Please run with sudo "
#    exit
#fi

whiptail --title "Pihole Speedtest Mod" --msgbox "Pihole Speedtest Mod installer." 8 78


if php -v | grep 'PHP 7' > /dev/null ; then 

	whiptail --title "Pihole Speedtest Mod" --msgbox "PHP 7.x found. Installing php5-sqlite " 8 78
	#sudo apt install php7.0-sqlite
else
	whiptail --title "Pihole Speedtest Mod" --msgbox "PHP 5.x found. Installing php7.0-sqlite" 8 78
	#sudo apt install php5-sqlite
fi
 

whiptail --title "Pihole Speedtest Mod" --msgbox "Instaling requiered pakages python-pip,speedtest-cli,sqlite3" 8 78

sudo apt install -y python-pip &> /dev/null
 
sudo pip install speedtest-cli &> /dev/null
 
sudo apt install -y sqlite3 &> /dev/null

whiptail --title "Pihole Speedtest Mod" --msgbox "Please set your timezone once prompted" 8 78

sudo dpkg-reconfigure tzdata  

whiptail --title "Pihole Speedtest Mod" --msgbox "Get latest pakage from github" 8 78

sudo su

cd /var/www/html

mv admin pihole_admin

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

whiptail --title "Pihole Speedtest Mod" --msgbox "Install complete" 8 78
