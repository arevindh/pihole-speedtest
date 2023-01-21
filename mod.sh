#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

if [ -n "$1" ]; then
    case "$1" in
        "in")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/install.sh | tac | tac | sudo bash
            ;;
        "up")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/update.sh | tac | tac | sudo bash -s -- $2 d
            ;;
        "un")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/uninstall.sh | tac | tac | sudo bash -s -- d # detached, avoid whiptail
            ;;
        *)
            # usage is up or un optionally followed by un or up
            echo "Usage: $0 [up [un]|un]"
            exit 1
            ;;
    esac
    if [ $? -eq 0 ]; then
        exit 0
    fi

    echo "Something went wrong."
    if [ "$1" == "up" ] || [ "$1" == "un" ]; then
        if [ ! -d /var/www/html/mod_admin ] || [ ! -f /opt/pihole/webpage.sh.mod ] || [ ! -f /opt/pihole/version.sh.mod ]; then
            echo "Speedtest Mod is not backed up, did not restore automatically."
        else
            echo "Restoring files..."
            cd /var/www/html
            rm -rf admin
            mv mod_admin admin
            cd /opt/pihole/
            mv webpage.sh.mod webpage.sh
            mv version.sh.mod version.sh
            echo "Files restored."
        fi
    fi
    echo "Please try again or try manually."
fi
