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
	fLog "Trying to restart auth on radius-secondary.ziplinknet.com";
	cDockerID="";
	cDockerID=`ssh radius-secondary.ziplinknet.com "docker ps | grep radiuscluster_auth-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" != "" ];then
		fLog $cDockerID;
		ssh radius-secondary.ziplinknet.com "docker restart $cDockerID";
	fi
	fLog "sleep 30s before checking";
	sleep 30;
	cDockerID="";
	cDockerID=`ssh radius-secondary.ziplinknet.com "docker ps | grep radiuscluster_auth-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" == "" ];then
		fLog "error";
		return;
	fi

	fLog "Trying to restart auth on radius-primary.ziplinknet.com";
	cDockerID="";
	cDockerID=`ssh radius-primary.ziplinknet.com "docker ps | grep radiuscluster_auth-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" != "" ];then
		fLog $cDockerID;
		ssh radius-primary.ziplinknet.com "docker restart $cDockerID";
	fi
	fLog "sleep 30s before checking";
	sleep 30;
	cDockerID="";
	cDockerID=`ssh radius-primary.ziplinknet.com "docker ps | grep radiuscluster_auth-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" == "" ];then
		fLog "error";
		return;
	fi
	fLog "restart auth end";
}

fRestartAcct()
{
	fLog "restart acct start";
	fLog "Trying to restart acct on radius-secondary.ziplinknet.com";
	cDockerID="";
	cDockerID=`ssh radius-secondary.ziplinknet.com "docker ps | grep radiuscluster_acct-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" != "" ];then
		fLog $cDockerID;
		ssh radius-secondary.ziplinknet.com "docker restart $cDockerID";
	fi
	fLog "sleep 30s before checking";
	sleep 30;
	cDockerID="";
	cDockerID=`ssh radius-secondary.ziplinknet.com "docker ps | grep radiuscluster_acct-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" == "" ];then
		fLog "error";
		return;
	fi

	fLog "Trying to restart acct on radius-primary.ziplinknet.com";
	cDockerID="";
	cDockerID=`ssh radius-primary.ziplinknet.com "docker ps | grep radiuscluster_acct-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" != "" ];then
		fLog $cDockerID;
		ssh radius-primary.ziplinknet.com "docker restart $cDockerID";
	fi
	fLog "sleep 30s before checking";
	sleep 30;
	cDockerID="";
	cDockerID=`ssh radius-primary.ziplinknet.com "docker ps | grep radiuscluster_acct-freeradius | cut -f 1 -d ' '"`;
	if [ "$cDockerID" == "" ];then
		fLog "error";
		return;
	fi
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
