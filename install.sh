#!/bin/bash -e

if [ ! -f /usr/local/bin/pihole ]; then
	echo "$(date) - Installing Pi-hole..."
	curl -sSLN https://install.pi-hole.net | sudo bash
fi

echo "$(date) - Verifying dependencies..."

PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3)
apt-get install sqlite3 $PHP_VERSION-sqlite3 jq -y
apt-get remove speedtest-cli -y

if [ ! -f /usr/bin/speedtest ]; then
	echo "$(date) - Installing speedtest..."
	# https://www.speedtest.net/apps/cli
	curl -sSLN https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
	sudo apt-get install speedtest -y
fi

echo "$(date) - Downloading Speedtest Mod..."

cd /var/www/html
rm -rf mod_admin
git clone https://github.com/arevindh/AdminLTE mod_admin
cd mod_admin
git fetch --tags
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latestTag

cd /opt/
rm -rf mod_pihole
git clone https://github.com/arevindh/pi-hole mod_pihole
cd mod_pihole
git fetch --tags
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latestTag
chmod +x advanced/Scripts/webpage.sh

db=$([ "$1" == "up" ] && echo "$3" || [ "$1" == "un" ] && echo "$2" || echo "$1")
curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/uninstall.sh | sudo bash -s -- $db
if [ "$1" == "un" ]; then
	exit 0
fi

if [ "$1" == "up" ]; then
	echo "$(date) - Updating Pi-hole..."
	PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up
	if [ "$2" == "un" ]; then
		exit 0
	fi
fi

echo "$(date) - Installing Speedtest Mod..."

cd /opt/
cp pihole/webpage.sh pihole/webpage.sh.org
cp mod_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh
rm -rf mod_pihole
cd /var/www/html
rm -rf org_admin
mv admin org_admin
cp -r mod_admin admin

if [ ! -f /etc/pihole/speedtest.db ] || [ "$db" == "db" ]; then
	echo "$(date) - Initializing database..."
	if [ -f /etc/pihole/speedtest.db ]; then
		mv /etc/pihole/speedtest.db speedtest.db.old
	fi
    cp scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
fi

pihole updatechecker local

echo "$(date) - Install complete"