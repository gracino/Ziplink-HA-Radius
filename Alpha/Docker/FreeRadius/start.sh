#!/bin/sh

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

envsubst '${cMysqlServer},${cMysqlLogin},${cMysqlPassword}' < /etc/raddb/sql.template > /etc/raddb/mods-available/sql;


cStatus="Fail";
cReturn="";
while [ $cStatus == "Fail" ]; do
  cReturn=`/usr/bin/mysql -B -N -h $cMysqlServer -u$cMysqlLogin -p$cMysqlPassword radius -e 'select id from radreply where id=2'|head -n 1`;
  if [ "$?" == "0" ] && [ "$cReturn" == "2" ];then
    cStatus="Ok";
  else
    echo "Waiting for MySQL";
    sleep 10;
  fi
done

sleep 3;
/usr/sbin/radiusd -X -f;
