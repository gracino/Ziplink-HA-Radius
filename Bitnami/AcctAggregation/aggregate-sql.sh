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
		#make delete SQL file. So we only delete what we dumped while locked.
		/delete.sh /tmp/radacct.$1.mysqldump.$cToday > /tmp/radacct.$1.delete.$cToday;
		if [ "$?" == "0" ];then
			/usr/bin/mysql -h $1 -u$cMysqlLogin -p$cMysqlPassword radius < /tmp/radacct.$1.delete.$cToday;
			if [ "$?" == "0" ];then
				rm /tmp/radacct.$1.mysqldump.$cToday;
				rm /tmp/radacct.$1.delete.$cToday;
			else
				echo "mysql radacct.$1.delete.$cToday failed!";
				exit 6;
			fi
		else
			echo "/delete.sh radacct.$1.delete.$cToday failed!";
			exit 5;
		fi
	else
		echo "mysql /tmp/radacct.$1.mysqldump.$cToday failed!";
		exit 4;
	fi
else
	echo "mysqldump $1 failed!";
	exit 1;
fi

exit 0;
