# Pi-hole Speedtest

## The Speedtest Mod for Pi-hole

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM)

![Speedtest Chart](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-chart.png)

---

Test your connection speed directly in the Pi-hole web UI! We try running speedtests using [Ookla's official `speedtest`](https://www.speedtest.net/apps/cli), unless you already have [`speedtest-cli`](https://github.com/sivel/speedtest-cli) or [`librespeed`](https://github.com/librespeed/speedtest-cli) installed as `/usr/bin/speedtest`, such as by selecting them with the `-s` option of the [Mod Script](https://github.com/arevindh/pihole-speedtest/wiki). Should any of these fail, the others will be tried.

Please keep in mind that:

* the more tests you run, the more data will be used, and
* any issues about weird results should be directed to the maintainers of whichever speedtest package is installed on your system, not here.

## Features

Pull requests and suggestions are welcome!

* Easy un/re/install and update with the Mod Script
* Supports Debian, Fedora, and derivatives with and without `systemd` (Docker too!)
* A pretty line or bar chart on the dashboard of any number of days
* Test ad-hoc and/or on a schedule, with automatic failover
* List the results and export them as a CSV file in the log
* View status, log, and servers in settings
* Flush or restore the database
* Customizable speedtest server

![Speedtest Settings](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-pref.png)

## Installing

Please use our Mod Script to install the latest version of the Mod; it automates the process of swapping Pi-hole's repos to our modded ones and ensures this is done efficiently. For information about running Pi-hole in Docker, including a Compose example, please refer to the official [repo](https://github.com/pi-hole/docker-pi-hole/) and [docs](https://docs.pi-hole.net/).

> **Note:** If you don't specify the `-s` option and don't have a speedtest package installed, Ookla's CLI will be installed when the first test runs.

Further Instructions: [Updating](https://github.com/arevindh/pihole-speedtest/wiki/Updating-Speedtest-Mod) | [Uninstalling](https://github.com/arevindh/pihole-speedtest/wiki/Uninstalling-Speedtest-Mod)

### Via the Shell

You can just pipe to bash:

    curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/mod | sudo bash

### With Docker

Simply change the image you're using to our modded one and proceed as usual. It's a drop-in replacement.

    ghcr.io/arevindh/pihole-speedtest:latest

You can also run the Mod Script inside every new container yourself. For example, if you're using Compose, by replacing the `image` line with:

    build:
        dockerfile_inline: |
            FROM pihole/pihole:latest
            RUN curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/mod | sudo bash

Then pull and rebuild without cache:

    docker compose pull; docker compose down; docker compose build --no-cache; docker compose up -d

## Buy me a ☕️

Buy @arevindh a ☕️ if you like this project :)

<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

@ipitio is not accepting donations at this time, but a star is always appreciated!
