## Docker HA Infrastructure

### Status

Just testing things out quickly at this time.

In the process of adding NGINX proxies to the initial docker-compose run file.

### Overview

The idea is to have multiple NGINX reverse proxy front ends via DNS multiple A record round robin.

These frontends, proxy traffic to/from (via health check pools) FreeRADIUS auth and acct servers.

The most important layer of this architecture is the underlying set of MySQL servers that shard, replicate and aggregate data.

The sharding happens via the DNS round robin and nginx selection of layer 1 MySQL servers.

For read only auth tables this is a non issue. The sharding of accounting data requires our system to
routinely aggregate all accounting data shards to a layer 2 MySQL backend cluster that is the only point of interface with
the ISP provisioning software: Sonar. Again replicating the auth data from this layer 2 to the read only layer 1 MySQL
servers is trivial.

The aggregation is straight forward but may limit the ability of Sonar to access up to date accounting records. 
Since this is usually a monthly billing procedure the timing issue can probably be met easily by using the data only on day 1 or similar cut off. Account holds based on usage can be handled with a special subsystem if
required by the ISP.

## Nginx Proxies

### Testing the UDP Proxy Configuration

Two FreeRadius servers behind one Nginx proxy:

 1. Test auth packet. Ok.
 1. Test accounting packet. Ok.

Test details auth:
```
[root@c7docker Docker]# docker-compose stop nginx0
Stopping docker_nginx0_1 ... done
[root@c7docker Docker]# docker cp nginx.conf docker_nginx0_1:/etc/nginx/nginx.conf
[root@c7docker Docker]# docker-compose start nginx0
Starting nginx0 ... done
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