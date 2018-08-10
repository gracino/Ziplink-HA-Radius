#!/bin/bash

if [ "$1" == "" ];then
	echo "usage: $0 <Host cIPNumber>";
	exit 0;
fi
if [ "$cMysqlLogin" == "" ];then
	exit 2;
fi
if [ "$cMysqlPassword" == "" ];then
	exit 3;
fi



#timestamp
cToday=`date +%Y%m%d%H%M`

#lock and dump
/usr/bin/mysqldump --insert-ignore --skip-extended-insert --no-create-db --no-create-info --lock-tables -h $1 -u$cMysqlLogin -p$cMysqlPassword \
	radius radacct | sed -e "s/([0-9]*,/(NULL,/g" > /tmp/radacct.$1.mysqldump.$cToday;
if [ "$?" == "0" ];then
	/usr/bin/mysql -h authdb-master -p$cMysqlPassword -u$cMysqlLogin radius < /tmp/radacct.$1.mysqldump.$cToday;
	if [ "$?" == "0" ];then
		exit 0;
		#/usr/bin/mysql -h $1 -u$cMysqlLogin -p$cMysqlPassword radius -e "truncate radacct";
		if [ "$?" == "0" ];then
			rm /tmp/radacct.$1.mysqldump.$cToday;
			exit 0;
		fi
	else
		echo "mysql $1 insert into authdb-master failed!";
		exit 4;
	fi
else
	echo "mysqldump $1 failed!";
	exit 1;
fi
