#!/bin/bash -e

set -e

if [ ! -f /usr/local/bin/pihole ]; then
	echo "$(date) - Installing Pi-hole..."
	curl -sSL https://install.pi-hole.net | sudo bash
fi

if [ "$1" != "un" ]; then
	echo "$(date) - Verifying Dependencies..."

	rm -f /etc/apt/sources.list.d/ookla_speedtest-cli.list
	apt-get update
	if [ ! -f /etc/apt/sources.list.d/ookla_speedtest-cli.list ]; then
		echo "$(date) - Adding speedtest source..."
		# https://www.speedtest.net/apps/cli
		if [ -e /etc/os-release ]; then
			. /etc/os-release

			base="ubuntu debian"
			os=${ID}
			dist=${VERSION_CODENAME}

			if [[ "${base//\"/}" =~ "${ID_LIKE//\"/}" ]]; then
				os=${ID_LIKE%% *}
				dist=${UBUNTU_CODENAME}
				[ -z "$dist" ] && dist=${VERSION_CODENAME}
			fi
			
			wget -O /tmp/script.deb.sh https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh > /dev/null 2>&1
			chmod +x /tmp/script.deb.sh
			os=$os dist=$dist /tmp/script.deb.sh
			rm -f /tmp/script.deb.sh
		else
			curl -sSLN https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
		fi
	fi
	PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3)
	apt-get install -y speedtest-cli- sqlite3 $PHP_VERSION-sqlite3 jq speedtest

	echo "$(date) - Downloading Latest Speedtest Mod..."

	cd /var/www/html
	rm -rf new_admin
	git clone --depth=1 https://github.com/arevindh/AdminLTE new_admin
	cd new_admin
	git fetch --tags -q
	latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
	git checkout $latestTag

	cd /opt/
	rm -rf new_pihole
	git clone --depth=1 https://github.com/arevindh/pi-hole new_pihole
	cd new_pihole
	git fetch --tags -q
	latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
	git checkout $latestTag
fi

db=$([ "$1" == "up" ] && echo "$3" || [ "$1" == "un" ] && echo "$2" || echo "$1")
curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/uninstall.sh | sudo bash -s -- $db
if [ "$1" == "un" ]; then
	rm -rf /opt/pihole/webpage.sh.*
	rm -rf /var/www/html/*_admin
	exit 0
fi

if [ "$1" == "up" ]; then
	echo "$(date) - Updating Pi-hole..."
	cd /var/www/html/admin
	git reset --hard origin/master
	git checkout master
	PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up
	if [ "$2" == "un" ]; then
		rm -rf /opt/pihole/webpage.sh.*
		rm -rf /var/www/html/*_admin
		exit 0
	fi
fi

echo "$(date) - Installing Speedtest Mod..."

cd /opt/
cp pihole/webpage.sh pihole/webpage.sh.org
cp new_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh.mod
rm -rf new_pihole
cd /var/www/html
rm -rf org_admin
mv admin org_admin
cp -r new_admin mod_admin
mv new_admin admin
cd - > /dev/null
cp pihole/webpage.sh.mod pihole/webpage.sh
chmod +x pihole/webpage.sh

if [ ! -f /etc/pihole/speedtest.db ] || [ "$db" == "db" ]; then
	echo "$(date) - Initializing Database..."
	if [ -f /etc/pihole/speedtest.db ]; then
		mv /etc/pihole/speedtest.db /etc/pihole/speedtest.db.old
	fi
    cp admin/scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
fi

pihole updatechecker local

echo "$(date) - Install Complete"
