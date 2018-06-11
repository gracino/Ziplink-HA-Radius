#!/bin/sh

#Provides stream section for nginx.conf for
#	load balancing 

#Provide default
if [ "$cUpstreamAuthServers" == "" ];then
	cUpstreamAuthServers="freeradius0:1812";
fi
if [ "$cUpstreamAcctServers" == "" ];then
	cUpstreamAcctServers="freeradius1:1813";
fi

cAuthServers=$(echo $cUpstreamAuthServers | tr ";" "\n")
cAcctServers=$(echo $cUpstreamAcctServers | tr ";" "\n")

echo "stream {";

echo "	upstream Authentication {";
for cServer in $cAuthServers;do
	echo "		server $cServer;";
done
echo "	}";

echo "	upstream Accounting {";
for cServer in $cAcctServers;do
	echo "		server $cServer;";
done
echo "	}";

echo "	server {";
echo "		listen 1812 udp;";
echo "		proxy_pass Authentication;";
echo "	}";
echo "	server {";
echo "		listen 1813 udp;";
echo "		proxy_pass Accounting;";
echo "	}";

echo "}";

exit 0;
