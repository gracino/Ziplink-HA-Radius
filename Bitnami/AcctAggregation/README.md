## Accounting Aggregation Subsystem

We need to periodically gather accounting data from all accounting DBs into the single master DB.

### How it works

We have a cluster of FreeRADIUS servers, with their DB server pair, handling accounting only. The process creates SQL radacct table records.
The records are updated by the NASs every so often. The records are "closed" by the NASs by setting the stop time etc.

For the ISP management system Sonar to work correctly it needs to see all these radacct table records on a single DB instance.
We move all the radacct records from the cluster DB servers to a main DB server. Once they are moved we remove them.

We need to only remove the "closed" records. E.g. records that will not be updated by the NASs anymore. Sonar wants to
see the unclosed records also. This has not been implemented correctly yet.

### Current Issues

 1. radacct records are not updated since they are removed.
 1. DB replication logs are filling up the docker containers. We need to mount them elsewhere. Or limit size somehow. ```Done```

### Roadmap

 1. Create an Alpine Linux container with MySQL client tools.
 1. Create BASH or SH scripts that will gather data and transfer to master DB.
 
### Details/Notes

 1. Alpine Linux container will require cron.
 1. Will require MySQL client tools.
 1. Can we get BASH installed in Alpine?.
 
 ### Resources
 
 https://mariadb.com/kb/en/library/using-and-maintaining-the-binary-log/
