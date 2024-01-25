#!/bin/bash
LOG_FILE="/var/log/pimod.log"

help() {
	echo "(Re)install Latest Speedtest Mod."
	echo "Usage: sudo $0 [up] [un] [db]"
	echo "up - update Pi-hole (along with the Mod)"
	echo "un - remove the mod (including all backups)"
	echo "db - flush database (restore for a short while after)"
}

setTags() {
	local path=${1-}
	local name=${2-}

	if [ ! -z "$path" ]; then
		cd "$path"
		git fetch --tags -q
		latestTag=$(git describe --tags $(git rev-list --tags --max-count=1))
	fi
	if [ ! -z "$name" ]; then
		localTag=$(pihole -v | grep "$name" | cut -d ' ' -f 6)
		[ "$localTag" == "HEAD" ] && localTag=$(pihole -v | grep "$name" | cut -d ' ' -f 7)
	fi
}

download() {
	local path=$1
	local name=$2
	local url=$3
	local src=${4-}
	local dest=$path/$name

	if [ ! -d $dest ]; then # replicate
		cd "$path"
		rm -rf "$name"
		git clone --depth=1 "$url" "$name"
		setTags "$name" "$src"
		if [ ! -z "$src" ]; then
			if [[ "$localTag" == *.* ]] && [[ "$localTag" < "$latestTag" ]]; then
				latestTag=$localTag
				git fetch --unshallow
			fi
		fi
	elif [ ! -z "$src" ]; then # revert
		setTags $dest
		git remote | grep -q upstream && git remote remove upstream
		git remote add upstream $url
		git fetch upstream -q
		git reset --hard upstream/master
	else # refresh
		setTags $dest
		git reset --hard origin/master
	fi

	git -c advice.detachedHead=false checkout $latestTag
}

install() {
	echo "$(date) - Installing any missing dependencies..."

	if [ ! -f /usr/local/bin/pihole ]; then
		echo "$(date) - Installing Pi-hole..."
		curl -sSL https://install.pi-hole.net | sudo bash
	fi

	if [ ! -f /etc/apt/sources.list.d/ookla_speedtest-cli.list ]; then
		echo "$(date) - Adding speedtest source..."
		# https://www.speedtest.net/apps/cli
		if [ -e /etc/os-release ]; then
			. /etc/os-release
			local base="ubuntu debian"
			local os=${ID}
			local dist=${VERSION_CODENAME}
			if [ ! -z "${ID_LIKE-}" ] && [[ "${base//\"/}" =~ "${ID_LIKE//\"/}" ]] && [ "${os}" != "ubuntu" ]; then
				os=${ID_LIKE%% *}
				[ -z "${UBUNTU_CODENAME-}" ] && UBUNTU_CODENAME=$(/usr/bin/lsb_release -cs)
				dist=${UBUNTU_CODENAME}
				[ -z "$dist" ] && dist=${VERSION_CODENAME}
			fi
			wget -O /tmp/script.deb.sh https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh >/dev/null 2>&1
			chmod +x /tmp/script.deb.sh
			os=$os dist=$dist /tmp/script.deb.sh
			rm -f /tmp/script.deb.sh
		else
			curl -sSLN https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
		fi
	fi
	local PHP_VERSION=$(php -v | head -n 1 | awk '{print $2}' | cut -d "." -f 1,2)
	apt-get install -y sqlite3 "${PHP_VERSION}-sqlite3" jq speedtest-cli- speedtest
	if [ -f /usr/local/bin/speedtest ]; then
		rm -f /usr/local/bin/speedtest
		ln -s /usr/bin/speedtest /usr/local/bin/speedtest
	fi

	echo "$(date) - Installing Latest Speedtest Mod..."

	download /opt mod_pihole https://github.com/arevindh/pi-hole
	download /var/www/html admin https://github.com/arevindh/AdminLTE web
	cd /opt
	cp pihole/webpage.sh pihole/webpage.sh.org
	cp mod_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh
	chmod +x pihole/webpage.sh

	if [ ! -f /etc/pihole/speedtest.db ]; then
		echo "$(date) - Creating Database..."
		cp /var/www/html/admin/scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
	fi

	pihole -a -s
	pihole updatechecker local
}

hashFile() {
	md5sum $1 | cut -d ' ' -f 1
}

purge() {
	echo "$(date) - Cleaning up..."
	rm -rf /opt/pihole/webpage.sh.*
	rm -rf /var/www/html/*_admin
	rm -rf /etc/pihole/speedtest.db.*
	rm -rf /etc/pihole/speedtest.db_*

	local init_db=/var/www/html/admin/scripts/pi-hole/speedtest/speedtest.db
	if [ -f $init_db ] && [ "$(hashFile $init_db)" == "$(hashFile /etc/pihole/speedtest.db)" ]; then
		rm -f /etc/pihole/speedtest.db
	fi
	exit 0
}

update() {
	echo "$(date) - Updating Pi-hole..."
	cd /var/www/html/admin
	git reset --hard origin/master
	git checkout master
	PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up
	if [ "${1-}" == "un" ]; then
		purge
	fi
}

manageHistory() {
	local init_db=/var/www/html/admin/scripts/pi-hole/speedtest/speedtest.db
	local curr_db=/etc/pihole/speedtest.db
	local last_db=/etc/pihole/speedtest.db.old
	if [ "${1-}" == "db" ]; then
		if [ -f $curr_db ] && [ -f $init_db ] && [ "$(hashFile $curr_db)" != "$(hashFile $init_db)" ]; then
			echo "$(date) - Flushing Database..."
			mv -f $curr_db $last_db
		elif [ -f $last_db ]; then
			echo "$(date) - Restoring Database..."
			mv -f $last_db $curr_db
		fi
	fi
}

uninstall() {
	if cat /opt/pihole/webpage.sh | grep -q SpeedTest; then
		echo "$(date) - Uninstalling Current Speedtest Mod..."

		if [ ! -f /opt/pihole/webpage.sh.org ]; then
			if [ ! -d /opt/org_pihole ]; then
				download /opt org_pihole https://github.com/pi-hole/pi-hole Pi-hole
			fi
			cd /opt
			cp org_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh.org
			rm -rf org_pihole
		fi

		pihole -a -su
		download /var/www/html admin https://github.com/pi-hole/AdminLTE web
		cd /opt/pihole/
		cp webpage.sh.org webpage.sh
		chmod +x webpage.sh
	fi

	manageHistory ${1-}
}

restore() {
	if [ ! -d /var/www/html/${1}_admin ] || [ ! -f /opt/pihole/webpage.sh.${1} ]; then
		echo "$(date) - A restore is not needed or one failed."
	else
		echo "$(date) - Restoring Files..."
		cd /var/www/html
		rm -rf admin
		mv ${1}_admin admin
		cd /opt/pihole/
		mv webpage.sh.${1} webpage.sh
		echo "$(date) - Files Restored"
	fi
}

abort() {
	echo "$(date) - Process Aborted" | sudo tee -a /var/log/pimod.log
	case ${1-} in
	up | un | db)
		restore mod
		;;
	*)
		restore org
		;;
	esac
	pihole restartdns
	echo "$(date) - Please try again or try manually."
	exit 1
}

commit() {
	pihole restartdns
	echo "$(date) - Done!"
	exit 0
}

main() {
	printf "Thanks for using Speedtest Mod!\nScript by @ipitio\n\n"
	local op=${1-}
	if [ "$op" == "-h" ] || [ "$op" == "--help" ]; then
		help
		exit 0
	fi
	if [ $EUID != 0 ]; then
		sudo "$0" "$@"
		exit $?
	fi
	set -Eeuo pipefail
	trap '[ "$?" -eq "0" ] && commit || abort $op' EXIT

	local db=$([ "$op" == "up" ] && echo "${3-}" || [ "$op" == "un" ] && echo "${2-}" || echo "$op")
	case $op in
	db)
		manageHistory $db
		;;
	un)
		uninstall $db
		purge
		;;
	up)
		uninstall $db
		update ${2-}
		install
		;;
	*)
		install
		;;
	esac
	exit 0
}

main "$@" 2>&1 | sudo tee -- "$LOG_FILE"
