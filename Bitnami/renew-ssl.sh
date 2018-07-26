#!/bin/bash

#Example usage
#19 0,12 * * * /root/renew-ssl.sh

docker run --rm --name letsencrypt -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/usr/share/nginx/html:/usr/share/nginx/html" certbot/certbot:latest renew --quiet
#docker run --rm --name letsencrypt -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/usr/share/nginx/html:/usr/share/nginx/html" certbot/certbot:latest renew 