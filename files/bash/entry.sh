#!/usr/bin/dumb-init /bin/sh
caddy -conf /opt/caddy/Caddyfile &
/usr/sbin/php-fpm7.1 --nodaemonize --fpm-config /etc/php/7.1/fpm/php-fpm.conf
