#!/bin/bash
#
#
#Restart all 4 FreeRADIUS containers

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" >> /tmp/restart.log; }

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

fLog "start";

fRestartAuth;
fRestartAcct;

fLog "end";
exit 0;
