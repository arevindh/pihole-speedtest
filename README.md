# Pi-hole Speedtest

## The Speedtest Mod for Pi-hole

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM)

![Speedtest Chart](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-chart.png)

---

Test your connection speed directly in the Pi-hole web interface! We try running speedtests using [Ookla's `speedtest`](https://www.speedtest.net/apps/cli), unless you already have [`speedtest-cli`](https://github.com/sivel/speedtest-cli) or [`librespeed`](https://github.com/librespeed/speedtest-cli) installed as `/usr/bin/speedtest`. Should one of these fail, the others will be tried.

Please keep in mind that:

* the more tests you run, the more data will be used, and
* any issues about weird results should be directed to the maintainers of whichever speedtest package is installed on your system, not here.

## Features

Pull requests and suggestions are welcome!

* Easy un/re/install and update with the Mod Script
* Everything is a button — no CLI required after install
* Supports Debian, Fedora, and derivatives with and without `systemd` (Docker too!)
* A pretty line or bar chart on the dashboard of any number of days
* Test ad-hoc and/or on a schedule, with automatic failover
* List the results and export them as a CSV file in the log
* View status, log, and servers in settings
* Flush or restore the database
* Customizable speedtest server

![Speedtest Settings](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-pref.png)

## Installing

To install (or reinstall) the latest version of the Mod and only the Mod, please use our Mod Script, which automates the process of swapping Pi-hole's repos to our modded ones and ensures this is done efficiently. For information about running Pi-hole in Docker, including a Compose example, please refer to the official [repo](https://github.com/pi-hole/docker-pi-hole/) and [docs](https://docs.pi-hole.net/).

> **Docker Note**
> You'll need to run the bash script from within the container after every rebuild if you're not using Compose.

<details>
<summary><strong>Via the Shell</strong></summary>

You can just pipe to bash!

    curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash -s

</details>

<details>
<summary><strong>Docker Compose</strong></summary>

Replace `image: pihole/pihole:latest` with the following in your `compose.yml`, then rebuild without cache.

    build:
        dockerfile_inline: |
            FROM pihole/pihole:latest
            RUN curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash -s

</details>

### Your Options

* `up, update` - also update Pi-hole, unless Systemd is not being used (ie. not in Docker)"
* `ba, backup` - preserve stock Pi-hole files for faster offline restore
* `on, online` - force online restore of stock Pi-hole files even if a backup exists
* `in, install` - skip restore of stock Pi-hole (for when not updating Pi-hole nor switching repos)
* `re, reinstall` - keep current version of the mod, if installed
* `un, uninstall` - remove the mod and its files, but keep the database
* `db, database` - flush/restore the database if it's not/empty (and exit if this is the only arg given)

### Usage Examples

* `sudo bash -s up ba on` - restore stock files online, update Pi-hole, backup stock files, and (re)install the latest version of the mod
* `sudo bash -s install` - (re)install the latest version of the mod without restoring stock files first
* `sudo bash -s in re db` - reinstall the current version of the mod without restoring stock files first and flush/restore the database

## Buy me a ☕️

Buy @arevindh a ☕️ if you like this project :)

<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
