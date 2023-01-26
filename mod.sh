#!/bin/bash
LOG_FILE="/var/log/pimod.log"

help() {
    echo "Install Latest Speedtest Mod."
    echo "Usage: sudo $0 [up] [un] [db]"
    echo "up - update Pi-hole"
    echo "un - remove the mod"
    echo "db - flush database"
    exit 1
}

mod() {
    printf "Thanks for using Speedtest Mod!\nScripts by @ipitio\n\n"

    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        help
    fi

    if [ $EUID != 0 ]; then
        sudo "$0" "$@"
        exit $?
    fi
        
    curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/install.sh | sudo bash -s -- $*
    if [ $? -eq 0 ]; then
        rm -rf /var/www/html/mod_admin
        rm -f /opt/pihole/webpage.sh.mod
        exit 0
    fi

    echo "$(date) - Something went wrong." | sudo tee -a /var/log/pimod.log
    if [ "$1" == "up" ] || [ "$1" == "un" ]; then
        if [ ! -d /var/www/html/mod_admin ] || [ ! -f /opt/pihole/webpage.sh.mod ]; then
            echo "$(date) - Speedtest Mod is not backed up (a restore is not needed or one failed)"
        else
            echo "$(date) - Restoring files..."
            cd /var/www/html
            rm -rf admin
            mv mod_admin admin
            cd /opt/pihole/
            mv webpage.sh.mod webpage.sh
            echo "$(date) - Files restored."
        fi
    fi
    echo "$(date) - Please try again or try manually."
    exit 1
}

mod "$@" 2>&1 | sudo tee -- "$LOG_FILE"
