#!/bin/bash

#Run some simple tests to check for failover.

cTest="radclient -f /etc/raddb/acct.start nginx0 acct SECRET";

nNumTests="2";

echo "$nNumTests acct tests with both servers running";
((c=1))
while true
do
	uId=`docker run --network docker_default --volume \`pwd\`/acct.start:/etc/raddb/acct.start freeradius:dev $cTest 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius0_1 2>/dev/null | tail -n 3 | grep "Cleaning up request packet ID $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok. $c"
	else
		docker logs docker_freeradius1_1 2>/dev/null | tail -n 3 | grep "Cleaning up request packet ID $uId" > /dev/null 2>&1;
		if [ $? == 0 ];then
			echo "docker_freeradius1_1 answered ok. $c"
		fi
	fi
	((c++)) && ((c>$nNumTests)) && break;
done

((c=1))
echo ""
echo "$nNumTests acct tests with only one server running (docker_freeradius0_1)";
docker-compose stop freeradius1;
while true
do
	uId=`docker run --network docker_default --volume \`pwd\`/acct.start:/etc/raddb/acct.start freeradius:dev $cTest 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius0_1 2>/dev/null | tail -n 3 | grep "Cleaning up request packet ID $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok. $c"
	fi
	((c++)) && ((c>$nNumTests)) && break;
done


((c=1))
echo ""
echo "$nNumTests acct tests with only one server running (docker_freeradius1_1)";
docker-compose start freeradius1;
docker-compose stop freeradius0;
while true
do
	uId=`docker run --network docker_default --volume \`pwd\`/acct.start:/etc/raddb/acct.start freeradius:dev $cTest 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius1_1 2>/dev/null | tail -n 3 | grep "Cleaning up request packet ID $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok. $c"
	fi
	((c++)) && ((c>$nNumTests)) && break;
done
docker-compose start freeradius0;
