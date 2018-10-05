#!/bin/bash

#Purpose
#	Purge MySQL binary logs
#Use Case
#	Every day via crontab we remove these records to keep
#	the DB from growing disk usage.

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" > /var/log/aggregate.log; }

#Required
if [ "$cMysqlLogin" == "" ];then
	exit 2;
fi
if [ "$cMysqlPassword" == "" ];then
	exit 3;
fi

fLog "start";

cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
  cReturn=`/usr/bin/mysql -B -N -h authdb-master -u$cMysqlLogin -p$cMysqlPassword radius -e 'SELECT "2"'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    fLog "Waiting for MySQL";
    sleep 50;
  fi
done

fLog "Purge authdb-master";
/usr/bin/mysql -B -N -h authdb-master -u$cMysqlLogin -p$cMysqlPassword \
	radius -e 'PURGE BINARY LOGS BEFORE NOW()-INTERVAL 2 DAY';


for cIP in `/usr/bin/dig $cMysqlServer +short`;do
	fLog "Purge slave $cIP";
	/usr/bin/mysql -B -N -h $cIP -u$cMysqlLogin -p$cMysqlPassword \
	radius -e 'PURGE BINARY LOGS BEFORE NOW()-INTERVAL 2 DAY';
done
fLog "end";
exit 0;
