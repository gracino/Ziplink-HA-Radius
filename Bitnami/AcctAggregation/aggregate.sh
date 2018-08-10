#!/bin/bash

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

cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
  cReturn=`/usr/bin/mysql -B -N -h $cMysqlServer -u$cMysqlLogin -p$cMysqlPassword radius -e 'SELECT "2"'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    echo "Waiting for MySQL";
    sleep 10;
  fi
done

#Aggregation Summary: 
#	Here we write lock radacct, mysqldump radacct data, 
#	if ok then we truncate radacct, release lock on radacct, Then we insert into master DB.
#	Need to handle all failure scenarios, especially those regarding trunc radacct. Since
#	that can cause data loss.
for cIP in `/usr/bin/dig $cMysqlServer +short`;do
	/aggregate-sql.sh $cIP;
done
exit 0;
