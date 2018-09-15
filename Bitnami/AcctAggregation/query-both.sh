#!/bin/bash

if [ "$1" == "" ];then
	echo "usage $0 <MySQL "quoted query"> ";
	exit 0;
fi

echo "$1";
for cIP in `/usr/bin/dig $cMysqlServer +short`;do
	echo $cIP;
	/usr/bin/mysql -h $cIP -u$cMysqlLogin -p$cMysqlPassword radius -e "$1";
done

