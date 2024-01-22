# Pihole Speedtest

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM)

Test your connection speed directly in the Pi-hole web interface!

## Features

This Speedtest Mod is, as the name suggests, a speedtest mod for Pi-hole. It runs speedtests using [Ookla's `speedtest`](https://www.speedtest.net/apps/cli) and logs the results in a database. You can:

* View the results in the web interface (Speedtest Log),
* Flush the Database, or
* Restore it until a new speedtest is run.

This limitation is of the script/GUI; you can always manipulate the database directly or export it as a CSV (Speedtest Log > Export As CSV); however, the Mod does also allow you to:

* Install, update, and uninstall itself,
* Set a custom speedtest server,
* Run tests ad-hoc and/or at set intervals, and
* Display a pretty line or bar chart on the dashboard of the last 1/2/4/7/30 days of tests.

![Settings](assets/settings.png)

Pull requests and suggestions are welcome!

Please note that the more tests you run, the more data will be used. Also note that `speedtest-cli` is no longer supported. Any issues relating to it or wonky results will be closed as wontfix and without additional reason or context.

## Usage

The provided script by @ipitio can un/re/install and update the mod, and manage its history. It accepts up to three arguments: any, all, or none of `up`, `un`, and `db`. They must be in that order; check usage for details. Its functionality is available via the web interface as well (Settings > Speedtest).

### Install

AKA (Re)Install Latest Mod and only Mod

```bash
curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/mod.sh | sudo bash
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Installing-Speedtest-Mod)

### Update

The above, but also updates Pi-hole. This is `(Re)install Latest` in the web interface.

```bash
curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/mod.sh | sudo bash -s up
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Updating--Speedtest-Mod)

### Uninstall

The Mod, not Pi-hole!

```bash
curl -sSLN https://github.com/arevindh/pihole-speedtest/raw/master/mod.sh | sudo bash -s un
```

[Manual Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Uninstalling-Speedtest-Mod)

## Release Notes

**Dec 9 2023**

Web 5.21

<details>

<summary>Older Notes</summary>

**June 8 2023**

Pi-hole 5.17.1 FTL 5.23, Web 5.20.1

**Jan 5 2023**

Pi-hole 5.14.2 FTL 5.20, Web v5.18

Wishing everyone a very happy New Year!

**Nov 24 2022**

Pi-hole 5.14.1 FTL 5.19.1, Web v5.17

**Oct 18 2022**

Pi-hole v5.13 FTL v5.18.2, Web v5.16

**Oct 1 2022**

Pi-hole 5.12.2 FTL 5.18.1 Admin LTE 5.15.1 , Docker 2022.09.4

**Sept 8 2022**

Pi-hole FTL v5.17, Web v5.14.2 and Core v5.12

**Sept 4 2022**

Pi-hole FTL v5.17, Web v5.14.1 and Core v5.12

**August 29 2022**

Pi-hole docker update

**July 11 2022**

Pi-hole core v5.11.4

**July 9 2022**

Pi-hole FTL v5.16, Web v5.13 and Core v5.11.3

**April 24 2022**

Pi-hole FTL v5.15, Web v5.12 and Core v5.10

**Mar 17 2022**

Speedtest mod update fixed [AdminLTE/51](https://github.com/arevindh/AdminLTE/issues/51)

**Feb 21 2022**

Speedtest mod update, Pi-hole Web v5.11.1

**Feb 16 2022**

* Updated Pi-hole FTL v5.14, Web v5.11 and Core v5.9

**Jan 8 2022**

* Updated to Pi-hole v5.8.1 Core / FTL v5.13 / 5.10.1 Web

**Dec 26 2021**

* Updated to pihole 5.7 Core / 5.9 Web

**Oct 24 2021**

* Updated to pihole 5.6 Core / 5.8 Web

**Oct 1 2021**

* Updated to pihole 5.5 Core / 5.7 Web

**Sept 16 2021**

* Updated to pihole 5.4 Core / 5.6 Web, disabled python mode selection , 'pihole -a -sn'

**April 15 2021**

* Updated to pihole 5.3.1 Core / 5.5 Web

**Jan 20 2021**

* Updated to pihole 5.2.4 Core / 5.3.1 Web

**Jan 18 2021**

* Updated to pihole 5.2.3 Core / 5.3 Web

**Dec 25 2020**

* Updated to pihole V5.2.2

**Dec 4 2020**

* Updated to pihole V5.2.1

**Nov 30 2020**

* Updated to pihole 5.2(Web) & 5.2(Core)

**OCt 9 2020**

* Fixed scheduler issues

**Aug 13 2020**

* Updated to pihole 5.1.1 (Web) & 5.1.2 (Core)

**July 29 2020**

* New feature : Displays 0 for failed speedtests : [Show failed speedtests as 0?](https://github.com/arevindh/pihole-speedtest/issues/43)

**July 20 2020**

* Updated to version v5.1

**June 4 2020**

* Added Support for official Speedtest-cli (v5.0.2)

**May 11 2020**

* Updated to admin version v5.0

**Feb 26 2020**

* Updated to admin version v4.3.3

**Sept 24 2019**

* Updated to admin version v4.3.2

**Sept 19 2019**

* Updated to core version v4.3.2

**July 2 2019**

* Updated to version v4.3.1

**May 19 2019**

* Updated to Pi-hole core, Web v4.3

**Mar 7 2019**

* Updated to Pi-hole core v4.2.2

**Feb 14 2019**

* Updated to Pi-hole core v4.2.1

**Dec 31 2018**

* Speedtest mod is up to date with Pi-hole v4.1.2

**Dec 12 2018**

* Speedtest mod is up to date with Pi-hole v4.1

**Aug 7 2018**

* Speedtest mod is up to date with Pi-hole v4.0
* Pi-hole v4.0 released on 2018-08-06. Speedtest mod integration is going on will take approx 3 to 5 days.

</details>

## Buy me a ☕️

Buy me a ☕️ if you like my projects :)

<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
