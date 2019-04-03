#!/bin/bash

#Example usage
#19 0,12 * * * /root/renew-ssl.sh

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" >> /tmp/renew-ssl.sh.log; }


fLog "start";
cToday=`date +"%b %d %H:%M:%S %Y GMT"`;
uTSToday=`date --date="$cToday" +%s`;
#echo $cToday;
#echo $uTSToday;
#echo "";
cExpirationDate=`echo | openssl s_client -servername radius.ziplinknet.com -connect radius.ziplinknet.com:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -f 2 -d "="`;
uTSExpiration=`date --date="$cExpirationDate" +%s`;
#echo $cExpirationDate;
#echo $uTSExpiration;

let "sDiff=$uTSExpiration-$uTSToday";
let "dDiff=$sDiff/(3600*24)";
#echo $sDiff $dDiff;

uDaysInAdvance="7";
if (( $dDiff >= $uDaysInAdvance ));then
	fLog "renewal not required $dDiff >= $uDaysInAdvance";
else
	fLog "renew cert $dDiff < $uDaysInAdvance";


	#turn off phpmyadmin to free ports 80 and 443
	docker service rm radiuscluster_phpmyadmin > /dev/null 2>&1;
	if [ "$?" == "0" ];then
		sleep 10;
		docker run --rm -p 443:443 -p 80:80 --name letsencrypt -v "/data/letsencrypt:/etc/letsencrypt" certbot/certbot renew --quiet;
	fi
	docker stack deploy --compose-file /root/Ziplink-HA-Radius/Bitnami/digitalocean.yml radiuscluster --with-registry-auth > /dev/null 2>&1;
fi

fLog "end";
exit 0;
