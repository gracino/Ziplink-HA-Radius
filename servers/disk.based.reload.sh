#!/bin/bash

#Purpose
#	Reload system if primary or secondary servers fill up past 60%

cLimit="60";


cPercentPrimary=`ssh radius-primary.ziplinknet.com df -h | grep vda1 | awk '{print $5}' | cut -f 1 -d "%"`;
if [ "$?" != "0" ];then
	echo "ssh radius-primary.ziplinknet.com failed!" | \
		mail -s disk.based.reload.report -r root@radius.ziplinknet.com wgg1970@gmail.com,gary@unxs.io;
else
	if [ $cPercentPrimary -gt $cLimit ];then
		echo "radius-primary.ziplinknet.com $cPercentPrimary% is greater than $cLimit%" | \
			 mail -s disk.based.reload.report -r root@radius.ziplinknet.com wgg1970@gmail.com,gary@unxs.io;
		/usr/local/sbin/reload.nas.sh;
		exit 0;
	fi
fi

cPercentSecondary=`ssh radius-secondary.ziplinknet.com df -h | grep vda1 | awk '{print $5}' | cut -f 1 -d "%"`;
if [ "$?" != "0" ];then
	echo "ssh radius-secondary.ziplinknet.com failed!" | \
		mail -s disk.based.reload.report -r root@radius.ziplinknet.com wgg1970@gmail.com,gary@unxs.io;
else
	if [ $cPercentSecondary -gt $cLimit ];then
		echo "radius-secondary.ziplinknet.com $cPercentSecondary% is greater than $cLimit%" | \
			 mail -s disk.based.reload.report -r root@radius.ziplinknet.com wgg1970@gmail.com,gary@unxs.io;
		/usr/local/sbin/reload.nas.sh;
		exit 0;
	fi
fi
