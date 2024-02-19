<div align="center">

# Pi-hole Speedtest

## The Speedtest Mod for Pi-hole

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM)

![Dashboard](assets/dashboard.png)

</div>

---

Test your connection speed directly in the Pi-hole web interface! We recommend running speedtests using [Ookla's `speedtest`](https://www.speedtest.net/apps/cli), but will respect your choice to use the potentially less accurate [`speedtest-cli`](https://github.com/sivel/speedtest-cli) if you already have it installed. Should one of these fail, the other will be tried.

Please keep in mind that:

* the more tests you run, the more data will be used, and
* any issues about inconsistent or inaccurate results should be directed to the maintainers of whichever speedtest package is installed on your system, not here.

## Features

Pull requests and suggestions are welcome!

* Fast and safe un/re/install and update script (Mod the Mod)
* Supports Debian, Fedora, and derivatives with and without `systemd`
* A pretty line or bar chart on the dashboard of any number of days
* Test ad-hoc and/or on a schedule, with automatic failover
* List the results and export them as a CSV in the log
* View logs and closest servers in settings
* Flush or restore the database
* Customizable speedtest server
* Everything is a button — no CLI required*

![Settings](assets/settings.png)

<sup>

*Post-install, of course.

</sup>

## Usage

The Mod Script by @ipitio can un/re/install and update the mod, and manage its history, for you. It accepts up to three arguments: any, all, or none of `up`, `un`, and `db`. They must be in that order; check usage for details. Its functionality is available via the web interface as well (Settings > Speedtest).

### Install

Install (or reinstall) the latest version of the Mod and only the Mod. For information about Pi-hole in Docker, including an example, please refer to their [repo](https://github.com/pi-hole/docker-pi-hole/) and [docs](https://docs.pi-hole.net/).

<details>
<summary><strong>Via the Shell</strong></summary>

You can just pipe to bash (inside the Docker container, if you're using it (after every rebuild (use Compose))).

```bash
curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Installing-Speedtest-Mod)

</details>

<details>
<summary><strong>Docker Compose</strong></summary>

Replace `image: pihole/pihole:latest` with the following in your `compose.yml`, then rebuild without cache.

```yaml
build:
    dockerfile_inline: |
        FROM pihole/pihole:latest
        RUN curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash
```

</details>

### Update

This is `(Re)install Latest` in the web interface.

> **Docker Note**
> You should only update via the shell or web if a new version of the Mod is released for the same Pi-hole core version. Neither the script nor the button in settings will run Pi-hole's update in Docker.

<details>
<summary><strong>Via the Shell</strong></summary>

The same as the above command, but also runs Pi-hole's update.

```bash
curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash -s up
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Updating--Speedtest-Mod)

</details>

<details>
<summary><strong>Docker Compose</strong></summary>

You can use the button or the shell, or rebuild the image without cache, for example:

```bash
docker compose down; docker compose build --no-cache; docker compose up -d
```

</details>

### Uninstall

The Mod and only the Mod will be removed. The database will be preserved if it's not empty, but its backup will be deleted; be careful when uninstalling and clearing history.

<details>
<summary><strong>Via the Shell</strong></summary>

You guessed it:

```bash
curl -sSLN https://github.com/arevindh/pi-hole/raw/master/advanced/Scripts/speedtestmod/mod.sh | sudo bash -s un
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Uninstalling-Speedtest-Mod)

</details>

<details>
<summary><strong>Docker Compose</strong></summary>

After using the button in settings, or the shell if you so choose, revert the `build` back to an `image` so the Mod doesn't reinstall on the next rebuild. You can also comment out the `RUN` line:

```yaml
build:
    dockerfile_inline: FROM pihole/pihole:latest
        # RUN curl -sSLN ...
```

</details>

## Release Notes

### v2.2.1

Feb 19 2024 - [Installation and Testing Enhancements](https://github.com/arevindh/pihole-speedtest/pull/159)

<details>
<summary><strong>Older</strong></summary>

### v2.2

Feb 13 2024 - [Docker and Fedora Support](https://github.com/arevindh/pihole-speedtest/pull/157)

### v2.1

Feb 04 2024 - [Theme changes, UI improvements, and a new settings](https://github.com/arevindh/pihole-speedtest/pull/153)

### v2.0

Jan 22 2024 - [Refactored Mod Script](https://github.com/arevindh/pihole-speedtest/pull/151)

### v1.9

Feb 11 2023 - [Mod Script and new settings](https://github.com/arevindh/pihole-speedtest/pull/130)

### v1.8

May 18 2022 - [Add CSV export](https://github.com/arevindh/AdminLTE/pull/56)

### v1.7

Mar 17 2022 - [Centered Icon](https://github.com/arevindh/AdminLTE/pull/52)

### v1.6

Feb 21 2022 - [Theme changes and UI improvements](https://github.com/arevindh/AdminLTE/pull/49)

### v1.5

Sep 16 2021 - Disabled Python mode

### v1.4

Oct 09 2020 - Fixed scheduler issues

### v1.3

Jul 29 2020 - Line chart and [displays 0 for failed speedtests](https://github.com/arevindh/pihole-speedtest/issues/43)

### v1.2

Jun 04 2020 - [Added Support for official Speedtest-cli (v5.0.2)](https://github.com/arevindh/AdminLTE/pull/24)

### v1.1

Aug 09 2019 - Support Raspbian Buster

### v1.0

Aug 08 2018 - [Initial Release](https://github.com/arevindh/AdminLTE/pull/11)

### v0.4

Apr 26 2018 - [Handle connection errors](https://github.com/arevindh/AdminLTE/pull/10)

### v0.3

Oct 20 2017 - [Make vertical axis start from 0](https://github.com/arevindh/AdminLTE/pull/2)

### v0.2

Oct 02 2017 - [Run speedtest now](https://github.com/arevindh/pi-hole/pull/1)

### v0.1

Jul 25 2017 - Create chart, settings, functions for speedtest, db

</details>

## Last Sync with Upstream

### Dec 09 2023

Web 5.21

<details>
<summary><strong>History</strong></summary>

### Jun 08 2023

Pi-hole 5.17.1 FTL 5.23, Web 5.20.1

### Jan 05 2023

Pi-hole 5.14.2 FTL 5.20, Web v5.18

Wishing everyone a very happy New Year!

### Nov 24 2022

Pi-hole 5.14.1 FTL 5.19.1, Web v5.17

### Oct 18 2022

Pi-hole v5.13 FTL v5.18.2, Web v5.16

### Oct 01 2022

Pi-hole 5.12.2 FTL 5.18.1 Admin LTE 5.15.1 , Docker 2022.09.4

### Sep 08 2022

Pi-hole FTL v5.17, Web v5.14.2 and Core v5.12

### Sep 04 2022

Pi-hole FTL v5.17, Web v5.14.1 and Core v5.12

### Aug 29 2022

Pi-hole docker update

### Jul 11 2022

Pi-hole core v5.11.4

### Jul 09 2022

Pi-hole FTL v5.16, Web v5.13 and Core v5.11.3

### Apr 24 2022

Pi-hole FTL v5.15, Web v5.12 and Core v5.10

### Feb 21 2022

Pi-hole Web v5.11.1

### Feb 16 2022

Updated Pi-hole FTL v5.14, Web v5.11 and Core v5.9

### Jan 08 2022

Updated to Pi-hole v5.8.1 Core / FTL v5.13 / 5.10.1 Web

### Dec 26 2021

Updated to pihole 5.7 Core / 5.9 Web

### Oct 24 2021

Updated to pihole 5.6 Core / 5.8 Web

### Oct 01 2021

Updated to pihole 5.5 Core / 5.7 Web

### Sep 16 2021

Updated to pihole 5.4 Core / 5.6 Web

### Apr 15 2021

Updated to pihole 5.3.1 Core / 5.5 Web

### Jan 20 2021

Updated to pihole 5.2.4 Core / 5.3.1 Web

### Jan 18 2021

Updated to pihole 5.2.3 Core / 5.3 Web

### Dec 25 2020

Updated to pihole V5.2.2

### Dec 04 2020

Updated to pihole V5.2.1

### Nov 30 2020

Updated to pihole 5.2(Web) & 5.2(Core)

### Aug 13 2020

Updated to pihole 5.1.1 (Web) & 5.1.2 (Core)

### Jul 20 2020

Updated to version v5.1

### May 11 2020

Updated to admin version v5.0

### Feb 26 2020

Updated to admin version v4.3.3

### Sep 24 2019

Updated to admin version v4.3.2

### Sep 19 2019

Updated to core version v4.3.2

### Jul 02 2019

Updated to version v4.3.1

### May 19 2019

Updated to Pi-hole core, Web v4.3

### Mar 07 2019

Updated to Pi-hole core v4.2.2

### Feb 14 2019

Updated to Pi-hole core v4.2.1

### Dec 31 2018

Speedtest mod is up to date with Pi-hole v4.1.2

### Dec 12 2018

Speedtest mod is up to date with Pi-hole v4.1

### Aug 07 2018

Speedtest mod is up to date with Pi-hole v4.0

Pi-hole v4.0 released on 2018-08-06. Speedtest mod integration is going on will take approx 3 to 5 days.

</details>

## Buy me a ☕️

Buy @arevindh a ☕️ if you like this project :)

<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
