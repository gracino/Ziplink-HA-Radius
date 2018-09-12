# Ziplink-HA-Radius
Ziplink high availability RADIUS project.

## Summary System Description From Job Messages

 1. Sonar is used as source of all customer authentication. 3k customers.
 1. Some NAS RADIUS requests time out, customer is disconnected. (Investigate: Change NAS settings to not go offline until RADIUS answers?) This was solved by fixing DB performance.
 1. HA setup should be architected. Has been with Docker swarm.
 1. Sonar "talks" to only one DB.
 1. Sonar has a "genie" that helps with initial setup. It is out of date with current FreeRADIUS. We will use PHPMyAdmin
 to add NASs via copy. edit and insert in the nas table.

### References

 1. https://sonar.software/resources
 1. https://github.com/SonarSoftware/freeradius_genie
 1. https://github.com/FreeRADIUS

## Summary Roadmap
 1. Survey current system. Done.
 1. Document current system. Done.
 1. Meeting with stakeholders. Done.
 1. Work on proposal. Done for current manual failover production system.
 1. Review proposal for Alpha system. Done.
 1. Approve proposal for Alpha system. Done.
 1. Work on alpha version. Done.
 1. Work on beta version. Docs, repo work, adding MySQL master and replication startup/config. Done.
 1. Testing Bitnami based beta version. Ok.
 1. CRITICAL: Developing aggregation container. Need to figure out how to aggregate closed radacct records. ```Done```
 1. CRITICAL: Volume work is required DB acctdb-slave runs out of space. ```Done```
 1. Weekly removal of closed radacct records. ```WorkInProgress```
 1. Weekly PURGE BINARY LOGS BEFORE NOW()-3DAYS. ```WorkInProgress```

## Production System Fix
Linux system admin work determined that the VM used was not resourced correctly. Lack of cores and RAM were
causing MySQL subsystem to lock. VM cores  were doubled and RAM also. Production system is now stable with little i/o wait time
and low uptime numbers.

## Other Notes

See Docker dir README.md for more information on Alpha system.

Some comments regarding questions from Roadmap items #2 and #5:

We did increase NAS timeout in the Radius config from 300ms to 600ms. Sounds reasonable. But we should aim for 200ms max transaction time.

I suspect Sonar talks to MySQL as that is the db that holds the custome info. Yes that is clear now. Thx!

The NAS also reports PPPoE address assigned to CPE and data using that traverses the PPPoE tunnel. That goes back into Sonar.

## Server Info

### Current Production

 1. 198.199.73.88: 64f07c48f0d6e148^

### Digital Ocean New Production Cluster

Reset broken terminal ```printf '\033[8;40;100t'```

```
 Droplet Name: Radius-HA1
	IP Address: 204.48.26.116:1221
	Username: root
	Password: 64f07c48f0d6e148^

Droplet Name: Radius-HA2
	IP Address: 167.99.6.83:1221
	Username: root
	Password: 64f07c48f0d6e148^

Droplet Name: Radius-HA3
	IP Address: 167.99.1.164:1221
	Username: root
	Password: 64f07c48f0d6e148^
	
Droplet Name: Radius-secondary-sfo
	IP address: 178.128.180.68
	Username: root
	Password:  64f07c48f0d6e148^
```
### Floating VIP

 1. radius.ziplinknet.com 165.227.255.1

### Web Apps

Docker Viz http://radius.ziplinknet.com:32712/

phpMyAdmin https://radius.ziplinknet.com/

### DNS NAMES with A Records

 1. radius.ziplinknet.com
 1. ha-radiusmgr.ziplinknet.com
 1. radius-primary.ziplinknet.com
 1. radius-secondary.ziplinknet.com


