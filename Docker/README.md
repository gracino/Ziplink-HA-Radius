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
 1. Test accounting packet.

Test details:
```
[root@c7docker Docker]# docker-compose stop nginx0
Stopping docker_nginx0_1 ... done
[root@c7docker Docker]# docker cp nginx.conf docker_nginx0_1:/etc/nginx/nginx.conf
[root@c7docker Docker]# docker-compose start nginx0
Starting nginx0 ... done
[root@c7docker Docker]# docker-compose up freeradius-test
Starting docker_freeradius-test_1 ... 
Starting docker_freeradius-test_1 ... done
Attaching to docker_freeradius-test_1
freeradius-test_1  | Sent Access-Request Id 158 from 0.0.0.0:48903 to 172.18.0.3:1812 length 77
freeradius-test_1  | 	User-Name = "testing"
freeradius-test_1  | 	User-Password = "password"
freeradius-test_1  | 	NAS-IP-Address = 172.18.0.4
freeradius-test_1  | 	NAS-Port = 0
freeradius-test_1  | 	Message-Authenticator = 0x00
freeradius-test_1  | 	Cleartext-Password = "password"
freeradius-test_1  | Received Access-Accept Id 158 from 172.18.0.3:1812 to 0.0.0.0:0 length 20
docker_freeradius-test_1 exited with code 0
[root@c7docker Docker]# 
```
