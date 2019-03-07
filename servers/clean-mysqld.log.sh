#!/bin/bash

#Purpose
#	truncate all container mysqld.log files.

for cFile in `find /var/lib/docker/overlay2/ -name mysqld.log -size +300M`;do
	cat /dev/null > $cFile;
done

#remove old detail files
for cFile in `find /var/lib/docker/overlay2/ -name "detail-*" -atime +0`;do
        #echo $cFile;
        rm $cFile;
done
