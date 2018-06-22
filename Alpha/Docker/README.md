## Docker HA Infrastructure

### Status

Alpha production level system is ready for automated testing.

Working on the testing framework and code.

### Alpha System Description.

 1. Single Nginx front end is a reverse proxy to 2 accounting FreeRadius servers and two FreeRadius authentication servers.
 1. Two MySQL (MariaDB) servers are being used by the two FreeRadius servers.
 1. Other FreeRadius container instances are used for generating RADIUS traffic.
 1. Testing subsystem uses Docker containers and bash scripting to generate RADIUS traffic, turn on and off backend FreeRadius servers,
look at logs results, and finally determine pass or no pass results.

### Overview Notes

The idea is to have multiple NGINX reverse proxy front ends via DNS multiple A record round robin.

These frontends, proxy traffic to/from (via health check pools) FreeRADIUS auth and acct servers.

The most complex layer of this architecture is the underlying set of MySQL servers that shard, and later aggregate accounting data. This happens when accounting data is eventually logged to different DBs on failover and failback. The ISP provisioning and billing software Sonar must be able to interface with the system through a single IP and the distributed accounting data must be eventually aggregated and consistent for billing/usage reports.

The sharding happens via the loadbalancing and nginx selection of healthy layer 1 MySQL servers.

For read only authentication tables the MySQL solution is very simple we only need to replicate these tables from the Sonar controlled master. Or use a multimaster replication setup for the readonly tables. As long as Sonar use is throttled this should present no issues, especially noting
the business logic that allows for slow convergence to a consistent state of the distributed db data.

The aggregation is straight forward but may limit the ability of Sonar to access up to date accounting records. 
Since this is usually a monthly billing procedure the timing issue can probably be met easily by using the data only on day 1 or similar cut off. Account holds based on usage can be handled with a special subsystem if
required by the ISP.

## Nginx Proxies

### Testing the UDP Proxy Configuration

Two FreeRadius servers behind one Nginx proxy:

 1. Test auth packet. Ok.
 1. Test accounting packet. Ok.
 
 First before any tests (until we have our own modified nginx):
 
 ```
[root@c7docker Docker]# docker-compose stop nginx0
Stopping docker_nginx0_1 ... done
[root@c7docker Docker]# docker cp nginx.conf docker_nginx0_1:/etc/nginx/nginx.conf
[root@c7docker Docker]# docker-compose start nginx0
Starting nginx0 ... done
 ```

Test details auth:
```
[root@c7docker Docker]# docker-compose up freeradius-authtest
Starting docker_freeradius-authtest_1 ... 
Starting docker_freeradius-authtest_1 ... done
Attaching to docker_freeradius-authtest_1
freeradius-authtest_1  | Sent Access-Request Id 158 from 0.0.0.0:48903 to 172.18.0.3:1812 length 77
freeradius-authtest_1  | 	User-Name = "testing"
freeradius-authtest_1  | 	User-Password = "password"
freeradius-authtest_1  | 	NAS-IP-Address = 172.18.0.4
freeradius-authtest_1  | 	NAS-Port = 0
freeradius-authtest_1  | 	Message-Authenticator = 0x00
freeradius-authtest_1  | 	Cleartext-Password = "password"
freeradius-authtest_1  | Received Access-Accept Id 158 from 172.18.0.3:1812 to 0.0.0.0:0 length 20
docker_freeradius-authtest_1 exited with code 0
[root@c7docker Docker]# 
```

Test details acct:
```
[root@c7docker Docker]# docker-compose up freeradius-accttest
Starting docker_freeradius-accttest_1 ... 
Starting docker_freeradius-accttest_1 ... done
Attaching to docker_freeradius-accttest_1
freeradius-accttest_1  | Sent Accounting-Request Id 138 from 0.0.0.0:33958 to 172.18.0.2:1813 length 101
freeradius-accttest_1  | Received Accounting-Response Id 138 from 172.18.0.2:1813 to 0.0.0.0:0 length 20
docker_freeradius-accttest_1 exited with code 0
[root@c7docker Docker]# docker exec -ti docker_freeradius1_1 cat /var/log/radius/radacct/172.18.0.2/detail-20180531
Thu May 31 21:13:24 2018
	Acct-Session-Id = "7000007A"
	User-Name = "JoeUser"
	NAS-IP-Address = 192.1.1.5
	NAS-Port-Id = "32"
	NAS-Port-Type = Async
	Acct-Status-Type = Start
	Connect-Info = "radclient test"
	Service-Type = Framed-User
	Framed-Protocol = PPP
	Framed-IP-Address = 192.1.1.66
	Acct-Delay-Time = 0
	Event-Timestamp = "May 31 2018 21:13:24 UTC"
	Tmp-String-9 = "ai:"
	Acct-Unique-Session-Id = "6e46eb58aa3916921b11573f3e023278"
	Timestamp = 1527801204
```

## MySQL Backend

User table is radcheck has 4000 rows. NAS authentication table is small, has only 17 rows at this time. The main performance issue is accounting, we are thinking about sharding via loadbalancing (nginx and/or dns multiple A records for nginx instances) and then aggregating accounting into single read only MySQL server for Sonar based billing/reporting. Only one user has a radreply entry for static IP assignment.

### Performance Issues

 1. MySQL should not be SSL for radius servers. Most likely just fine for remote Sonar access to aggregated accounting server.
 1. Connection should be via UNIX domain sockets for local radiusd servers. Alpha solution uses standard TCP.
 1. MySQL should run on host node and not be a Docker container. Alpha solution testing will determine if this an issue.
 1. Authentication is a read only operation as far as MySQL goes for the auth radius server.
 1. Read only optimization: Use radcheck as a MyISAM table and then ```ALTER TABLE radcheck ROW_FORMAT=Fixed;```, See https://dba.stackexchange.com/questions/22509/optimizing-mysql-for-read-only/22552#22552
 1. Or radcheck authentication table could be kept in RAM via: Scan the entire contents of the table on each startup to preload the content into memory with ```SELECT * FROM radcheck ORDER BY username``` for each table followed by ```SELECT username FROM radcheck ORDER BY username```.
 1. By having many radacct MySQL instances we can scale perfectly as far as getting acct data saved somewhere. If Sonar
 or other tools use some kind of session limitation the sharding will be in the way. And the aggregation system must be
 able to keep up.

### IMPORTANT FreeRadius Version 3

The solution being delivered is using the new version 3. The current production system is version 2.

```
[root@c7docker Docker]# docker exec -ti docker_freeradius0_1 /usr/sbin/radiusd -v
radiusd: FreeRADIUS Version 3.0.13, for host x86_64-alpine-linux-musl, built on Jun 15 2017 at 15:06:29
FreeRADIUS Version 3.0.13
Copyright (C) 1999-2017 The FreeRADIUS server project and contributors
```
