#!/bin/bash

#Purpose
#	Delete closed radacct records older than 48 hours ago.
#Use Case
#	Every hour via crontab we remove these records to keep
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
    sleep 10;
  fi
done

/usr/bin/mysql -B -N -h authdb-master -u$cMysqlLogin -p$cMysqlPassword \
	radius -e 'DELETE FROM radacct WHERE acctstoptime<DATE_SUB(NOW(),INTERVAL 2 DAY)';
fLog "end";
exit 0;
