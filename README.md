# Pihole Speedtest

[![Join the chat at https://gitter.im/pihole-speedtest/community](https://badges.gitter.im/pihole-speedtest/community.svg)](https://gitter.im/pihole-speedtest/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  [![Discord](https://badgen.net/badge/icon/discord?icon=discord&label)](https://discord.gg/TW9TfyM)


## By me a coffee 

Buy me a ☕️ if you like my projects :)


<a href="https://www.buymeacoffee.com/itsmesid" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

[Install Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Installing-Speedtest-Mod)

[Update Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Updating--Speedtest-Mod)

## Update

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



## About the project

So [project](https://blog.arevindh.com/2017/07/13/add-speedtest-to-pihole-webui/) is just another fun project integrating speedtest to PiHole Web UI.

Note : It’s just a quick solution , nowhere near perfect . If you made it better please let me know [here](https://github.com/arevindh/pihole-speedtest/issues)

It will be using speedtest.net on background for testing. More frequent the speed tests more data will used.

What does this mod have in extra ?

1. Speedtest results of 1/2/4/7/30  days as graph.
2. Custom speed test server selection.
3. Detailed speedtest results page.
4. Ability to schedule speedtest interval.

## Use Official CLI Mode for best results.

## Inconsistency for python Mode
-------------

This Project is based on speedtest-cli. The text below is from their repository [readme](https://github.com/sivel/speedtest-cli#inconsistency) file.

> It is not a goal of this application to be a reliable latency reporting tool.

> Latency reported by this tool should not be relied on as a value indicative of ICMP
> style latency. It is a relative value used for determining the lowest latency server
> for performing the actual speed test against.

> There is the potential for this tool to report results inconsistent with Speedtest.net.
> There are several concepts to be aware of that factor into the potential inconsistency:

> 1. Speedtest.net has migrated to using pure socket tests instead of HTTP based tests
> 2. This application is written in Python
> 3. Different versions of Python will execute certain parts of the code faster than others
> 4. CPU and Memory capacity and speed will play a large part in inconsistency between
   Speedtest.net and even other machines on the same network

> Issues relating to inconsistencies will be closed as wontfix and without
> additional reason or context.

[Uninstall Instructions](https://github.com/arevindh/pihole-speedtest/wiki/Uninstalling-Speedtest-Mod)
