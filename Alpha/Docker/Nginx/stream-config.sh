#!/bin/sh

#Provides stream section for nginx.conf for
#	load balancing 

#Provide default
if [ "$cUpstreamAuthServers" == "" ];then
  cUpstreamAuthServers="auth-freeradius:1812;auth-freeradius:1812";
fi
if [ "$cUpstreamAcctServers" == "" ];then
  cUpstreamAcctServers="acct-freeradius:1813;acct-freeradius:1813";
fi

cAuthServers=$(echo $cUpstreamAuthServers | tr ";" "\n")
cAcctServers=$(echo $cUpstreamAcctServers | tr ";" "\n")

for cServer in $cAuthServers;do
  cStatus="Fail";
  while [ $cStatus == "Fail" ]; do
    cServerIp=$(echo $cServer | tr ":" "\n" | head -n 1);
    /bin/ping -W 1 -c 1 $cServerIp > /dev/null 2>&1;
    if [ "$?" == "0" ];then
      cStatus="Ok";
    else
      sleep 10;
    fi
  done
done

for cServer in $cAcctServers;do
  cStatus="Fail";
  while [ $cStatus == "Fail" ]; do
    cServerIp=$(echo $cServer | tr ":" "\n" | head -n 1);
    /bin/ping -W 1 -c 1 $cServerIp > /dev/null 2>&1;
    if [ "$?" == "0" ];then
      cStatus="Ok";
    else
      sleep 10;
    fi
  done
done

echo "stream {";

echo "	upstream Authentication {";
for cServer in $cAuthServers;do
  echo "		server $cServer max_fails=1 fail_timeout=1s;";
done
echo "	}";

echo "	upstream Accounting {";
cSecond="False";
for cServer in $cAcctServers;do
  echo "		server $cServer max_fails=1 fail_timeout=1s;";
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
