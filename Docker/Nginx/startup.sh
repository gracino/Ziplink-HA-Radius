#!/bin/sh

cat /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf;
/usr/sbin/stream-config.sh >> /etc/nginx/nginx.conf;

exec /usr/sbin/nginx -g "daemon off;";
