#!/bin/bash

# if run counter is > 3, then exit
if [ ! -f /tmp/pimod.txt ]; then
    echo 1 > /tmp/pimod.txt
else
    run_counter=$(cat /tmp/pimod.txt)
    run_counter=$((run_counter + 1))
    echo $run_counter > /tmp/pimod.txt
fi

if [ $run_counter -gt 3 ]; then
    echo "Too many runs. Please run command again or try manually."
    exit 1
fi

if [ -n "$1" ]; then
    case "$1" in
        "in")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/install.sh | bash
            ;;
        "up")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/update.sh | bash -s -- $2
            ;;
        "un")
            curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/uninstall.sh | bash
            ;;
        *)
            # usage is up or un optionally followed by un or up
            echo "Usage: $0 [up [un]|un]"
            rm -f /tmp/pimod.txt
            exit 1
            ;;
    esac
    if [ $? -eq 0 ]; then
        rm -f /tmp/pimod.txt
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
    whiptail --title "Pihole Speedtest Mod" --yesno "Would you like to try again?" 8 78
    if [ $? -eq 0 ]; then
        $0 $1 $2
    fi
    rm -f /tmp/pimod.txt
    exit 1
fi