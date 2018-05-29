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

 1. Test accounting packet.
 1. Test auth packet.
