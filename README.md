# Pi-hole Speedtest

![Speedtest Chart](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-chart.png)

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM) [![Docker Build](https://github.com/arevindh/pihole-speedtest/actions/workflows/publish.yml/badge.svg)](https://github.com/arevindh/pihole-speedtest/actions/workflows/publish.yml)

This project is a few things, the major parts being a Pi-hole extension and a speedtest runner. Install the Speedtest Mod in a breeze with the one-liners and Docker images [below](https://github.com/arevindh/pihole-speedtest?tab=readme-ov-file#installing).

## The Runner

The Test Script is a standalone tool that can be used to run speedtests on automated Debian or Fedora based systems. It will install a speedtest CLI if one hasn't been, run a test, and save the results to a new or existing database. You can use it to test your connection, monitor your ISP, or check the speed of your VPN. Let us know how you're using it! See usage for details.

    curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/test | sudo bash -s -- -o ~/speedtest.db

Please keep in mind that the more tests you run, the more data will be used, and any issues about weird results should be directed to the maintainers of whichever speedtest CLI is installed on your system, not here.

## The Extension

The Mod allows you to use the Test Script and run speedtests right from the Pi-hole web UI! Install, set a testing interval and customize the chart in Settings, kick back, and watch the results come in on the Dashboard. Other features include:

* Run tests ad-hoc
* Export data as CSV
* View status, logs, and servers
* Flush or restore the database
* Select speedtest server

![Speedtest Settings](https://raw.githubusercontent.com/arevindh/AdminLTE/master/img/st-pref.png)

### Installing

The Mod Script is our installation manager; it automates the process of applying our patches. It supports Debian, Fedora, and derivatives with and without `systemd`. Docker, too! You can use it to quickly try out the Mod and uninstall it if you don't like it. For information about running Pi-hole in Docker, including a Compose example, please refer to the official [repo](https://github.com/pi-hole/docker-pi-hole/) and [docs](https://docs.pi-hole.net/). Post-install instructions are [below](https://github.com/arevindh/pihole-speedtest?tab=readme-ov-file#post-install).

#### Via the Shell

You can just pipe to bash:

    curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/mod | sudo bash

#### With Docker

The above goes for Docker as well. We use the Dockerfile in this repo to build an image with the Mod Script already applied. Simply change the image you're using to ours and proceed as usual. It's a drop-in replacement.

    ghcr.io/arevindh/pihole-speedtest:latest

You can also run the Mod Script inside every new container yourself. For example, if you're using Compose, by replacing the `image` line with:

    build:
        dockerfile_inline: |
            FROM pihole/pihole:latest
            RUN curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/mod | sudo bash

Then pull and rebuild without cache:

    docker compose pull; docker compose down; docker compose build --no-cache; docker compose up -d

### Post Install

After installation, the Mod will use the Test Script to mediately install [Ookla's official `speedtest`](https://www.speedtest.net/apps/cli), unless you already have [`speedtest-cli`](https://github.com/sivel/speedtest-cli) or [`librespeed-cli`](https://github.com/librespeed/speedtest-cli) installed as `/usr/bin/speedtest`. You can install and switch between all of these with the Mod Script's `-s` option. Please refer to our [wiki](https://github.com/arevindh/pihole-speedtest/wiki) to see how to use this option and what others are available. Should any of the CLI packages fail at runtime, the others will be tried.

Further Instructions: [Updating](https://github.com/arevindh/pihole-speedtest/wiki/Updating-Speedtest-Mod) | [Uninstalling](https://github.com/arevindh/pihole-speedtest/wiki/Uninstalling-Speedtest-Mod)

## Buy me a ☕️

Buy @arevindh a ☕️ if you like this project :)

<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

@ipitio is not accepting donations at this time, but a star is always appreciated!
