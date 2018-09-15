#!/bin/bash

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" > /var/log/aggregate.log; }

#We check for a known value that is only available after MySQL is completely available for use.

#Required
if [ "$cMysqlServer" == "" ];then
	exit 1;
fi
if [ "$cMysqlLogin" == "" ];then
	exit 2;
fi
if [ "$cMysqlPassword" == "" ];then
	exit 3;
fi

fLog "start";

fLog "$cMysqlServer section start";
cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
  cReturn=`/usr/bin/mysql -B -N -h $cMysqlServer -u$cMysqlLogin -p$cMysqlPassword radius -e 'SELECT "2"'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    fLog "Waiting for MySQL";
    sleep 10;
  fi
done

for cIP in `/usr/bin/dig $cMysqlServer +short`;do
	fLog "$cIP";
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'STOP SLAVE';
	if [ "$?" != "0" ];then
    		fLog "STOP SLAVE error!";
		exit 4;
	fi
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'SET GLOBAL Replicate_Ignore_Table="radius.radacct"';
	if [ "$?" != "0" ];then
    		fLog "SET GLOBAL error!";
		exit 5;
	fi
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'START SLAVE';
	if [ "$?" != "0" ];then
    		fLog "START SLAVE error!";
		exit 6;
	fi
done

if [ "$cMysqlServerAuth" == "" ];then
	exit 1;
fi

cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
  cReturn=`/usr/bin/mysql -B -N -h $cMysqlServerAuth -u$cMysqlLogin -p$cMysqlPassword radius -e 'SELECT "2"'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    fLog "Waiting for MySQL";
    sleep 10;
  fi
done

fLog "$cMysqlServerAuth section start";
for cIP in `/usr/bin/dig $cMysqlServerAuth +short`;do
	fLog "$cIP";
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'STOP SLAVE';
	if [ "$?" != "0" ];then
    		fLog "STOP SLAVE error!";
		exit 4;
	fi
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'SET GLOBAL Replicate_Ignore_Table="radius.radacct"';
	if [ "$?" != "0" ];then
    		fLog "SET GLOBAL error!";
		exit 5;
	fi
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e 'START SLAVE';
	if [ "$?" != "0" ];then
    		fLog "START SLAVE error!";
		exit 6;
	fi
done

fLog "normal end";
exit 0;
