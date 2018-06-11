#!/bin/bash

#Run some simple tests to check for failover.

echo "10 auth tests with both servers running";
while true
do
	uId=`docker run --network docker_default freeradius:dev radtest Sonar_1170982 AF745JB6L75P nginx0 0 SECRET 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius0_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok."
	fi
	docker logs docker_freeradius1_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius1_1 answered ok."
	fi
	((c++)) && ((c>=10)) && break;
done

((c=0))
echo ""
echo "10 auth tests with only one server running (docker_freeradius0_1)";
docker-compose stop freeradius1;
sleep 5;
while true
do
	uId=`docker run --network docker_default freeradius:dev radtest Sonar_1170982 AF745JB6L75P nginx0 0 SECRET 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius0_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok."
	fi
	docker logs docker_freeradius1_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius1_1 answered ok."
	fi
	((c++)) && ((c>=10)) && break;
done


((c=0))
echo ""
echo "10 auth tests with only one server running (docker_freeradius1_1)";
docker-compose start freeradius1;
docker-compose stop freeradius0;
sleep 5;
while true
do
	uId=`docker run --network docker_default freeradius:dev radtest Sonar_1170982 AF745JB6L75P nginx0 0 SECRET 2>&1 | head -n 1 | awk '{printf $4}'`;
	echo Request Id=$uId;
	docker logs docker_freeradius0_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius0_1 answered ok."
	fi
	docker logs docker_freeradius1_1 2>/dev/null | tail -n 3 | grep "Sent Access-Accept Id $uId" > /dev/null 2>&1;
	if [ $? == 0 ];then
		echo "docker_freeradius1_1 answered ok."
	fi
	((c++)) && ((c>=10)) && break;
done
