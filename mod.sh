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
	else # replace
		setTags $dest
		if [ ! -z "$src" ]; then
			if [ "$url" != "old" ]; then
				git config --global --add safe.directory "$dest"
				git remote -v | grep -q "old" || git remote rename origin old
				git remote -v | grep -q "origin" && git remote remove origin
				git remote add origin $url
			else
				git remote rename origin new
				git remote rename old origin
				git remote remove new
			fi
			git fetch origin -q
		fi
		git reset --hard origin/master
	fi

	git -c advice.detachedHead=false checkout $latestTag
	cd ..
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
	cp pihole/webpage.sh pihole/webpage.sh.org
	cp mod_pihole/advanced/Scripts/webpage.sh pihole/webpage.sh.mod

	download /var/www/html admin https://github.com/arevindh/AdminLTE web
	cd /opt
	if [ ! -f pihole/webpage.sh.bak ] && [ -f pihole/webpage.sh ]; then
		cp pihole/webpage.sh pihole/webpage.sh.bak
	fi
	cp pihole/webpage.sh.mod pihole/webpage.sh
	chmod +x pihole/webpage.sh

	if [ ! -f /etc/pihole/speedtest.db ]; then
		local last_db=/etc/pihole/speedtest.db.old
		if [ -f $last_db ]; then
			echo "$(date) - Restoring Database..."
			mv $last_db /etc/pihole/
		else
			echo "$(date) - Creating Database..."
			cp /var/www/html/admin/scripts/pi-hole/speedtest/speedtest.db /etc/pihole/
		fi
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
	rm -rf /opt/mod_pihole

	local init_db=/var/www/html/admin/scripts/pi-hole/speedtest/speedtest.db
	local curr_db=/etc/pihole/speedtest.db
	if [ -f $init_db ] && [ -f $curr_db ] && [ "$(hashFile $init_db)" == "$(hashFile /etc/pihole/speedtest.db)" ]; then
		rm -f /etc/pihole/speedtest.db
	fi
}

update() {
	echo "$(date) - Updating Pi-hole..."
	cd /var/www/html/admin
	git reset --hard origin/master
	git checkout master
	PIHOLE_SKIP_OS_CHECK=true sudo -E pihole -up
	if [ "${1-}" == "un" ]; then
		purge
		exit 0
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
	if [ -f /opt/pihole/webpage.sh ] && cat /opt/pihole/webpage.sh | grep -q SpeedTest; then
		echo "$(date) - Uninstalling Current Speedtest Mod..."

		cd /opt
		cp pihole/webpage.sh pihole/webpage.sh.mod
		if [ ! -f /opt/pihole/webpage.sh.bak ]; then
			cp pihole/webpage.sh pihole/webpage.sh.bak
		fi

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

abort() {
	echo "$(date) - Process Aborting..." | sudo tee -a /var/log/pimod.log

	if [ -f /opt/pihole/webpage.sh.bak ]; then
		cp /opt/pihole/webpage.sh.bak /opt/pihole/webpage.sh
		chmod +x /opt/pihole/webpage.sh
		rm -f /opt/pihole/webpage.sh.bak
	fi

	if [ -d /var/www/html/admin/.git/refs/remotes/old ]; then
		download /var/www/html admin old web
	fi

	if [ -f /etc/pihole/speedtest.db.old ] && [ ! -f /etc/pihole/speedtest.db ]; then
		mv /etc/pihole/speedtest.db.old /etc/pihole/speedtest.db
	fi

	if [ ! -f /opt/pihole/webpage.sh ] || ! cat /opt/pihole/webpage.sh | grep -q SpeedTest; then
		purge
	fi

	pihole restartdns
	echo "$(date) - Please try again or try manually."
	exit 1
}

commit() {
	echo "$(date) - Almost Done..."
	cd /var/www/html/admin
	git remote -v | grep -q "old" && git remote remove old
	rm -f /opt/pihole/webpage.sh.bak
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
