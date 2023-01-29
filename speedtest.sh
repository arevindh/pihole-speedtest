#!/bin/bash
FILE=/tmp/speedtest.log
readonly setupVars="/etc/pihole/setupVars.conf"
serverid=$(grep 'SPEEDTEST_SERVER' ${setupVars} | cut -d '=' -f2)
start=$(date +"%Y-%m-%d %H:%M:%S")

speedtest() {
    if grep -q official <<< "$(/usr/bin/speedtest --version)"; then
        if [[ -z "${serverid}" ]]; then
            /usr/bin/speedtest --accept-gdpr --accept-license -f json-pretty
        else
            /usr/bin/speedtest -s $serverid --accept-gdpr --accept-license -f json-pretty  
        fi
    else
        if [[ -z "${serverid}" ]]; then
            /usr/bin/speedtest --json --share --secure
        else
            /usr/bin/speedtest -s $serverid --json --share --secure
        fi
    fi
}

internet() {
    stop=$(date +"%Y-%m-%d %H:%M:%S")
    res="$(<$FILE)"
    server_name=$(jq -r '.server.name' <<< "$res")
    server_dist=0

    if grep -q official <<< "$(/usr/bin/speedtest --version)"; then
        download=$(jq -r '.download.bandwidth' <<< "$res" | awk '{$1=$1*8/1000/1000; print $1;}' | sed 's/,/./g')
        upload=$(jq -r '.upload.bandwidth' <<< "$res" | awk '{$1=$1*8/1000/1000; print $1;}' | sed 's/,/./g')
        isp=$(jq -r '.isp' <<< "$res")
        server_ip=$(jq -r '.server.ip' <<< "$res")
        from_ip=$(jq -r '.interface.externalIp' <<< "$res")
        server_ping=$(jq -r '.ping.latency' <<< "$res")
        share_url=$(jq -r '.result.url' <<< "$res")
    else
        download=$(jq -r '.download' <<< "$res" | awk '{$1=$1/1000/1000; print $1;}' | sed 's/,/./g')
        upload=$(jq -r '.upload' <<< "$res" | awk '{$1=$1/1000/1000; print $1;}' | sed 's/,/./g')
        isp=$(jq -r '.client.isp' <<< "$res")
        server_ip=$(jq -r '.server.host' <<< "$res")
        from_ip=$(jq -r '.client.ip' <<< "$res")
        server_ping=$(jq -r '.ping' <<< "$res")
        share_url=$(jq -r '.share' <<< "$res")
    fi

    sep="\t"
    quote=""
    opts=
    sep="$quote$sep$quote"
    printf "$quote$start$sep$stop$sep$isp$sep$from_ip$sep$server_name$sep$server_dist$sep$server_ping$sep$download$sep$upload$sep$share_url$quote\n"
    sqlite3 /etc/pihole/speedtest.db "insert into speedtest values (NULL, '${start}', '${stop}', '${isp}', '${from_ip}', '${server_name}', ${server_dist}, ${server_ping}, ${download}, ${upload}, '${share_url}');"
}

tryagain(){
    if grep -q official <<< "$(/usr/bin/speedtest --version)"; then
        apt-get install -y speedtest- speedtest-cli
    else
        apt-get install -y speedtest-cli- speedtest
    fi
    start=$(date +"%Y-%m-%d %H:%M:%S")
    speedtest > $FILE && internet || exit 1
}

main() {
    if [ $EUID != 0 ]; then
        sudo "$0" "$@"
        exit $?
    fi
    echo "Test has been initiated, please wait."
    speedtest > "$FILE" && internet || tryagain
    exit 0
}
    
main
