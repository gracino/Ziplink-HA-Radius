#!/bin/bash

fLog() { echo "`date +%b' '%d' '%T` $0[$$]: $@" > /var/log/aggregate.log; }

#simple aggregation
#we can recover from failures by monitoring /tmp and using files therein to fix problems.
#we probably need to save the files on persistent storage for this to really work

if [ "$1" == "" ];then
	echo "usage: $0 <Host cIPNumber> [debug]";
	exit 0;
fi
if [ "$cMysqlLogin" == "" ];then
	exit 2;
fi
if [ "$cMysqlPassword" == "" ];then
	exit 3;
fi

cDebug="No";
if [ "$2" == "debug" ];then
	cDebug="Yes";
	fLog "Debug on";
fi

fLog "start";

#timestamp
cToday=`date +%Y%m%d%H%M`

#lock and dump
/usr/bin/mysqldump --replace --skip-extended-insert --no-create-db --no-create-info --lock-tables -h $1 -u$cMysqlLogin -p$cMysqlPassword \
	radius radacct | sed -e "s/([0-9]*,/(NULL,/g" > /tmp/radacct.$1.mysqldump.$cToday;
if [ "$?" == "0" ];then
	cWordCount=`/usr/bin/grep -wc REPLACE /tmp/radacct.$1.mysqldump.$cToday`;
	if [ "$cWordCount" == "0" ];then
		fLog "No REPLACE /tmp/radacct.$1.mysqldump.$cToday";
		if [ "$cDebug" == "No" ];then
			rm /tmp/radacct.$1.mysqldump.$cToday;
		fi
		exit 0;
	fi
	#move data to master
	/usr/bin/mysql -h authdb-master -p$cMysqlPassword -u$cMysqlLogin radius < /tmp/radacct.$1.mysqldump.$cToday;
	if [ "$?" == "0" ];then
		#make delete SQL file. So we only delete what we dumped while locked.
		/delete.sh /tmp/radacct.$1.mysqldump.$cToday > /tmp/radacct.$1.delete.$cToday;
		if [ "$?" == "0" ];then
			#delete from acct slave only what we dumped
			/usr/bin/mysql -h $1 -u$cMysqlLogin -p$cMysqlPassword radius < /tmp/radacct.$1.delete.$cToday;
			if [ "$?" == "0" ];then
				if [ "$cDebug" == "No" ];then
					rm /tmp/radacct.$1.mysqldump.$cToday;
					rm /tmp/radacct.$1.delete.$cToday;
				fi
			else
				fLog "mysql radacct.$1.delete.$cToday failed!";
				exit 6;
			fi
		else
			fLog "/delete.sh radacct.$1.delete.$cToday failed!";
			exit 5;
		fi
	else
		fLog "mysql /tmp/radacct.$1.mysqldump.$cToday failed!";
		exit 4;
	fi
else
	fLog "mysqldump $1 failed!";
	exit 1;
fi

fLog "normal end";
exit 0;
