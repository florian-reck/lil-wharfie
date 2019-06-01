#!/bin/bash
find /opt/nextcloud/config -print0 |xargs -0 chown www-data:www-data 
find /opt/nextcloud/data -print0 |xargs -0 chown www-data:www-data 
find /opt/nextcloud/apps -print0 |xargs -0 chown www-data:www-data 
find /var/lib/mysql -print0 |xargs -0 chown mysql:mysql

/etc/init.d/redis-server start
/etc/init.d/mysql start
/etc/init.d/cron start
killall lighttpd &>/dev/null
/etc/init.d/lighttpd restart
