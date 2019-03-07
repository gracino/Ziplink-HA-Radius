#!/bin/bash

for cLog in `find /var/lib/docker/ -name radius.log | grep -w diff`;do
	echo $cLog;
	cat /dev/null > $cLog;
done
