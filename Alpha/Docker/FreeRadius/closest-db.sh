#!/bin/bash

cClosestServer=`/usr/bin/dig $cMysqlServer +short | while read cServers ; do ping -c 1 -w 1 $cServers 2>/dev/null | fgrep ' time=' | sed 's/ time=/\n/' | grep ' ms' | sed 's/ ms$/ /' | sed 's/\./ |/' | cut -d "|" -f1 | tr -d '\n'; if [ $? -eq 0 ]; then echo "$cServers"; fi; done | grep "^[0-9]" | sort -un | head -1 | awk '{print $2}'`

echo $cClosestServer;
exit 0;
