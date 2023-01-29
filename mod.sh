#!/bin/bash
LOG_FILE="/var/log/pimod.log"

help() {
    echo "(Re)install Latest Speedtest Mod."
    echo "Usage: sudo $0 [up] [un] [db]"
    echo "up - update Pi-hole"
    echo "un - remove the mod"
    echo "db - flush database"
}

download() {
	if [ ! -f /usr/local/bin/pihole ]; then
		echo "$(date) - Installing Pi-hole..."
		curl -sSL https://install.pi-hole.net | sudo bash
	fi

	if	[ -z "${1-}" ] || [ "$1" == "up" ]; then
		echo "$(date) - Verifying Dependencies..."

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
			apt-get install -y speedtest-cli- speedtest
			if [ -f /usr/local/bin/speedtest ]; then
				rm -f /usr/local/bin/speedtest
				ln -s /usr/bin/speedtest /usr/local/bin/speedtest
			fi
		fi
		PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3)
		apt-get install -y sqlite3 $PHP_VERSION-sqlite3 jq

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
}

install() {
	echo "$(date) - Installing Speedtest Mod..."

	cd /opt/
	cp pihole/webpage.sh pihole/webpage.sh.org
	cp new_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh.mod
	rm -rf new_pihole
	cd /var/www/html
	rm -rf org_admin
	mv admin org_admin
	rm -rf mod_admin
	cp -r new_admin mod_admin
	mv new_admin admin
	cd - > /dev/null
	cp pihole/webpage.sh.mod pihole/webpage.sh
	chmod +x pihole/webpage.sh

	pihole updatechecker local

	echo "$(date) - Install Complete"
}

purge() {
	rm -rf /opt/pihole/webpage.sh.*
	rm -rf /var/www/html/*_admin
}

update() {
	echo "$(date) - Updating Pi-hole..."
	cd /var/www/html/admin
	git reset --hard origin/master
    git checkout master
	PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up
	echo "$(date) - Update Complete"
	if [ "${1-}" == "un" ]; then
		purge
	fi
}

uninstall() {
	echo "$(date) - Restoring Pi-hole..."
	
	cd /opt/
	if [ ! -f /opt/pihole/webpage.sh.org ]; then
        echo "$(date) - Downloading Pi-hole..."
		rm -rf org_pihole
		git clone -q https://github.com/pi-hole/pi-hole org_pihole 
		cd org_pihole
		git fetch --tags -q
		localVer=$(pihole -v | grep "Pi-hole" | cut -d ' ' -f 6)
		remoteVer=$(curl -s https://api.github.com/repos/pi-hole/pi-hole/releases/latest | grep "tag_name" | cut -d '"' -f 4)
		if [[ "$localVer" < "$remoteVer" && "$localVer" == *.* ]]; then
			remoteVer=$localVer
		fi
		git checkout $remoteVer
		cp advanced/Scripts/webpage.sh ../pihole/webpage.sh.org
		cd - > /dev/null
		rm -rf org_pihole
	fi
	
	cd /var/www/html
	if [ ! -d /var/www/html/org_admin ]; then
	    echo "$(date) - Downloading AdminLTE..."
		rm -rf org_admin
		git clone -q https://github.com/pi-hole/AdminLTE org_admin
		cd org_admin
		git fetch --tags -q
		localVer=$(pihole -v | grep "AdminLTE" | cut -d ' ' -f 6)
		remoteVer=$(curl -s https://api.github.com/repos/pi-hole/AdminLTE/releases/latest | grep "tag_name" | cut -d '"' -f 4)
		if [[ "$localVer" < "$remoteVer" && "$localVer" == *.* ]]; then
			remoteVer=$localVer
		fi
		git checkout $remoteVer
		cd - > /dev/null
	fi

	if [ "${1-}" == "db" ]; then
		echo "$(date) - Configuring Database..."
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
}

abort() {
    echo "$(date) - Process Aborted" | sudo tee -a /var/log/pimod.log
	case $1 in
		up | un)
			if [ ! -d /var/www/html/mod_admin ] || [ ! -f /opt/pihole/webpage.sh.mod ]; then
				echo "$(date) - A restore is not needed or one failed."
			else
				echo "$(date) - Restoring Files..."
				cd /var/www/html
				rm -rf admin
				mv mod_admin admin
				cd /opt/pihole/
				mv webpage.sh.mod webpage.sh
				echo "$(date) - Files Restored."
			fi
			;;
		*)
			if [ ! -d /var/www/html/org_admin ] || [ ! -f /opt/pihole/webpage.sh.org ]; then
				echo "$(date) - A restore is not needed or one failed."
			else
				echo "$(date) - Restoring Files..."
				cd /var/www/html
				rm -rf admin
				mv org_admin admin
				cd /opt/pihole/
				mv webpage.sh.org webpage.sh
				echo "$(date) - Files Restored."
			fi
			;;
	esac
    echo "$(date) - Please try again or try manually."
    exit 1
}

clean() {
    rm -rf /var/www/html/mod_admin
    rm -f /opt/pihole/webpage.sh.mod
    exit 0
}

main() {
	printf "Thanks for using Speedtest Mod!\nScript by @ipitio\n\n"
	op=$1
    if [ "$op" == "-h" ] || [ "$op" == "--help" ]; then
        help
		exit 0
    fi
    if [ $EUID != 0 ]; then
        sudo "$0" "$@"
        exit $?
    fi
	set -Eeuo pipefail
	trap '[ "$?" -eq "0" ] && clean || abort $op' EXIT

	db=$([ "$op" == "up" ] && echo "${3-}" || [ "$op" == "un" ] && echo "${2-}" || echo "$op")
	download $op
	uninstall $db
	case $op in
		un)
			purge
			;;
		up)
			update ${2-}
			;&
		*)
			install
			;;
	esac
	exit 0
}

main "$@" 2>&1 | sudo tee -- "$LOG_FILE"
