#!/bin/bash

#Example usage
#19 0,12 * * * /root/renew-ssl.sh

#turn off phpmyadmin to free ports 80 and 443
docker service rm radiuscluster_phpmyadmin > /dev/null 2>&1;
if [ "$?" == "0" ];then
	sleep 10;
	docker run --rm -p 443:443 -p 80:80 --name letsencrypt -v "/data/letsencrypt:/etc/letsencrypt" certbot/certbot renew --quiet;
fi
docker stack deploy --compose-file /root/Ziplink-HA-Radius/Bitnami/digitalocean.yml radiuscluster --with-registry-auth > /dev/null 2>&1;
