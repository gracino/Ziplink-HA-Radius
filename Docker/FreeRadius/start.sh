#!/bin/sh

#we check for a known value that is only available after MySQL is completely available for use.

cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
	cReturn=`/usr/bin/mysql -B -N -h mysql0 -uradius -plksjdf78498kdfjh radius -e 'select id from radreply where id=2'|head -n 1`;
	if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
		cStatus="Ok";
	else
		echo "Waiting for MySQL";
		sleep 10;
	fi
done

/usr/sbin/radiusd -X -f;
