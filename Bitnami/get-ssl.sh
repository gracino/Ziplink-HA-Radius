#!/bin/bash
#usage
#other port 80 and port 443 containers must be off


if [ "$1" == "" ];then
	echo "usage: $0 <letsencrypt domain string>"
	exit 0;
fi

#just in case... see mknodedirs.sh
mkdir -p /data/letsencrypt;

#docker run --rm -p 443:443 -p 80:80 --name letsencrypt -v "/data/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly -n -m "certbot@unxs.io" -d "$1" --standalone --agree-tos
docker run --rm -p 443:443 -p 80:80 --name letsencrypt -v "/data/letsencrypt:/etc/letsencrypt" certbot/certbot certonly -n -m "certbot@unxs.io" -d "$1" --standalone --agree-tos
