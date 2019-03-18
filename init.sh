#!/bin/bash

#make sure dir exists
mkdir -p /var/lib/ganglia/rrds

#ganglia and rrdcached run as user nobody
if [ "$FIXPERMISSION" = true ]; then
    chown -R nobody /var/lib/ganglia/rrds
fi
usermod -aG www-data nobody

#rrd-socketfile
export RRDCACHED_ADDRESS=unix:/tmp/rrdcached.sock
echo '<?php $conf["rrdcached_socket"] = "unix:/tmp/rrdcached.sock"; ?>' > /etc/ganglia-webfrontend/conf.php

mkdir -P /var/log/ganglia
chown nobody:www-run /var/log/ganglia

#restart apache
service apache2 restart

#start rrdcached as user nobody
#the limited.sock is for the webfrontend
su nobody -c 'rrdcached -F -p /tmp/rrdcached.pid -s www-data -m 664 -l unix:/tmp/rrdcached.sock -b /var/lib/ganglia/rrds -B -w 1800 -z 1800 -f 3600 -o /var/log/ganglia/rrdcached' -s /bin/sh

#start gmond
service ganglia-monitor start

#start gmetad in debugmode
gmetad -d 1 -p /var/run/gmetad.pid -c /etc/ganglia/gmetad.conf
