#!/bin/bash

#we check for a known value that is only available after MySQL is completely available for use.

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
  cReturn=`/opt/bitnami/mariadb/bin/mysql -B -N -h $cMysqlServer -u$cMysqlLogin -p$cMysqlPassword radius -e 'SELECT "2"'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    echo "Waiting for MySQL";
    sleep 10;
  fi
done

#Now we can setup the master
/opt/bitnami/mariadb/bin/mysql -h $cMysqlServer -u$cMysqlLogin -p$cMysqlPassword radius < /tmp/setup.sql
