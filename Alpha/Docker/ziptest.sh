#!/bin/bash

cAcctTest="radclient -f /etc/raddb/acct.start radius-primary.ziplinknet.com acct SECRET";
docker run --volume `pwd`/acct.start:/etc/raddb/acct.start docker0.unxs.io:5000/freeradius:dev $cAcctTest;

cAuthTest="radtest Sonar_1170982 AF745JB6L75P radius-primary.ziplinknet.com 0 SECRET";
docker run docker0.unxs.io:5000/freeradius:dev $cAuthTest;
