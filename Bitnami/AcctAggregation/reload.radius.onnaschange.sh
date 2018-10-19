#!/bin/bash
#
#

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" >> /tmp/reload.log; }

fLog "start";
cContainerID=`docker ps | grep authdb-master | cut -f 1 -d " "`;
if [ "$?" != "0" ];then
	fLog "No authdb-master cContainerID";
	exit 1;
fi
fLog $cContainerID;



fRestartAuth()
{
	fLog "restart auth start";
	#get worker nodes
	for cNode in `docker node ls | grep -v Leader | grep -v HOSTNAME | awk '{print $2}'`;do
		cID=`ssh $cNode docker ps | grep radiuscluster_auth-freeradius | head -n 1| cut -f 1 -d " "`
		if [ "$cID" != "" ];then
			fLog "$cNode $cID";
			ssh $cNode docker restart $cID > /dev/null;
		fi
	done
	fLog "restart auth end";
}

fRestartAcct()
{
	fLog "restart acct start";
	#get worker nodes
	for cNode in `docker node ls | grep -v Leader | grep -v HOSTNAME | awk '{print $2}'`;do
		cID=`ssh $cNode docker ps | grep radiuscluster_acct-freeradius | head -n 1| cut -f 1 -d " "`
		if [ "$cID" != "" ];then
			fLog "$cNode $cID";
			ssh $cNode docker restart $cID > /dev/null;
		fi
	done
	fLog "restart acct end";
}


cReturn=`docker exec $cContainerID mysql -B -N -uroot -p64f07c48f0 radius -e "SELECT 'true' FROM information_schema.tables WHERE table_schema='radius' AND table_name='nas' AND update_time>DATE_SUB(NOW(),INTERVAL 30 MINUTE)"`;
if [ "$?" == "0" ];then
	if [ "$cReturn" == "true" ];then
		fRestartAuth;
		fRestartAcct;
	fi
else
	fLog "docker exec error";
	exit 2;
fi
fLog "end";
exit 0;
