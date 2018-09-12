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

cClosestServer=`/usr/bin/dig $cMysqlServer +short | while read cServers ; do ping -c 1 -w 1 $cServers 2>/dev/null | fgrep ' time=' | sed 's/ time=/\n/' | grep ' ms' | sed 's/ ms$/ /' | sed 's/\./ |/' | cut -d "|" -f1 | tr -d '\n'; if [ $? -eq 0 ]; then echo "$cServers"; fi; done | grep "^[0-9]" | sort -un | head -1 | awk '{print $2}'`;
export cMysqlDBIp=$cClosestServer;

envsubst '${cMysqlDBIp},${cMysqlLogin},${cMysqlPassword}' < /etc/raddb/sql.template > /etc/raddb/mods-available/sql;

sleep 3;
/usr/sbin/radiusd -f;
