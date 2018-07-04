#!/bin/bash

#usage
#other port 80 and port 443 containers must be off

docker run --rm -p 443:443 -p 80:80 --name letsencrypt -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly -n -m "certbot@unxs.io" -d docker3.unxs.io --standalone --agree-tos
