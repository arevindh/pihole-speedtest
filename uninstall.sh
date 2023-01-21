#!/bin/bash -e

pihole_current=$(pihole -v | grep "Pi-hole" | cut -d ' ' -f 3)
adminlte_current=$(pihole -v | grep "Web" | cut -d ' ' -f 6)
pihole_ftl_current=$(pihole -v | grep "FTL" | cut -d ' ' -f 6)

echo "Reverting files..."

cd /var/www/html
rm -rf mod_admin
mv admin mod_admin
if [ -d /var/www/html/org_admin ]; then
    mv org_admin admin
else
    git clone https://github.com/pi-hole/AdminLTE admin
    cd admin
    git checkout $adminlte_current
fi

cd /opt/pihole/
cp webpage.sh webpage.sh.mod
cp version.sh version.sh.mod
if [ -f /opt/pihole/webpage.sh.org ] && [ -f /opt/pihole/version.sh.org ]; then
    mv webpage.sh.org webpage.sh
    mv version.sh.org version.sh
else
    cd ..
    mv pihole mod_pihole
    git clone https://github.com/pi-hole/pi-hole pihole
    cd pihole
    git checkout $pihole_current
fi
rm -f /opt/pihole/webpage.sh.mod
rm -f /opt/pihole/version.sh.mod

echo "Files reverted."
exit 0