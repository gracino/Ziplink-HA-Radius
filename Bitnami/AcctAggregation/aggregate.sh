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
	fLog "/root/cleanup";
	/root/cleanup $cIP $cMysqlLogin $cMysqlPassword > /var/log/aggregate.log;
	fLog "aggregate-sql.sh";
	/aggregate-sql.sh $cIP;
done
fLog "end";
exit 0;
