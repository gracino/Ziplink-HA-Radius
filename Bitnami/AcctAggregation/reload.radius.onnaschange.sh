#!/bin/bash
#
#

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" >> /tmp/reload.log; }

cat /dev/null > /tmp/reload.log;
fLog "start";
cContainerID=`docker ps | grep authdb-master | cut -f 1 -d " "`;
if [ "$?" != "0" ];then
	fLog "No cContainerID";
	exit 1;
fi
fLog $cContainerID;

cReturn=`docker exec $cContainerID mysql -B -N -uroot -p64f07c48f0 radius -e "SELECT 'true' FROM information_schema.tables WHERE table_schema='radius' AND table_name='nas' AND update_time>DATE_SUB(NOW(),INTERVAL 30 MINUTE)"`;
if [ "$?" == "0" ];then
	if [ "$cReturn" == "true" ];then
		fLog "restart auth";
		docker service update --force radiuscluster_auth-freeradius >> /tmp/reload.log 2>&1;
		if [ $? != 0 ];then
			fLog "restart auth error";
		fi
		fLog "restart acct";
		docker service update --force radiuscluster_acct-freeradius >> /tmp/reload.log 2>&1;
		if [ $? != 0 ];then
			fLog "restart acct error";
		fi
	fi
else
	fLog "docker exec error";
	exit 2;
fi
fLog "end";
exit 0;
