#!/bin/bash

cServer="radius-primary.ziplinknet.com";
cSecret="00401440daa8b82f991bec8d378e39b7";

AuthTest() {

	echo "Testing $cServer,$cUsername,$cPassword,$cSecret,$cType"
	cAuthTest="radtest $cType $cUsername $cPassword $cServer 0 $cSecret";
	docker run --rm docker0.unxs.io:5000/freeradius:dev $cAuthTest;

}

cUsername="abc123";
cPassword="abc123";
cType="";
AuthTest;

cUsername="Sonar_949322";
cPassword="lVgFXAnsJT";
cType="-t chap";
AuthTest;

cServer="radius-secondary.ziplinknet.com";
cUsername="Sonar_949322";
cPassword="lVgFXAnsJT";
cType="-t chap";
AuthTest;

exit 0;

cUsername="testing";
cPassword="aksjdghwuey91bec8d378e39b7";
cType="";
AuthTest;

cUsername="unxsio";
cPassword="thisisthepasswd";
cType="-t chap";
AuthTest;

cUsername="Sonar_949322";
cPassword="lVgFXAnsJT";
cType="-t chap";
AuthTest;

exit 0;

cAcctTest="radclient -f /etc/raddb/acct.start $cServer acct SECRET";
docker run --rm --volume `pwd`/acct.start:/etc/raddb/acct.start docker0.unxs.io:5000/freeradius:dev $cAcctTest;

exit 0;

cServer="radius-secondary.ziplinknet.com";

cAcctTest="radclient -f /etc/raddb/acct.start $cServer acct SECRET";
docker run --rm --volume `pwd`/acct.start:/etc/raddb/acct.start docker0.unxs.io:5000/freeradius:dev $cAcctTest;

cAuthTest="radtest Sonar_1170982 AF745JB6L75P $cServer 0 SECRET";
docker run --rm docker0.unxs.io:5000/freeradius:dev $cAuthTest;
