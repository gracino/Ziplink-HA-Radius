#!/bin/bash

#Purpose
#	truncate all large container mysqld.log files.

for cFile in `find /var/lib/docker/overlay2/ -name mysqld.log -size +300M`;do
	#echo $cFile;
        #break;
	cat /dev/null > $cFile;
done
