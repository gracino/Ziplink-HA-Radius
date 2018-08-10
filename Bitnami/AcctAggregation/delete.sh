#!/bin/bash

#Turn mysqldump into a DELETE FROM radacct sql file

if [ "$1" == "" ];then
	echo "usage: $0 ReplaceFileName";
	exit 0;
fi

#for cAcctUniqueId in `grep "INSERT  IGNORE INTO" $1 | cut -f 3 -d ,`;do
for cAcctUniqueId in `grep "REPLACE " $1 | cut -f 3 -d ,`;do
	echo "DELETE FROM radacct WHERE acctuniqueid=$cAcctUniqueId;";
done
