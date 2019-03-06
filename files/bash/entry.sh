#!/usr/bin/dumb-init /bin/sh
caddy -conf /opt/caddy/Caddyfile &
/usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf
