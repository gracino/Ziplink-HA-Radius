## Accounting Aggregation Subsystem

We need to periodically gather accounting data from all accounting DBs into the single master DB.

### How it works

We have a cluster of FreeRADIUS servers, with their DB server pair, handling accounting only. The process creates SQL radacct table records. The records are updated by the NASs every so often. The records are "closed" by the NASs by setting the stop time. The records are updated by the NASs and the ```acctupdatetime``` updated accordingly.

The NASs may round-robin the radacct destined UDP packets. Therefore multiple but same ```acctsessionid``` records may be spread across the DB cluster. This will cause our automated orphan session closing to maybe use and older ```acctupdatetime``` than it should. This does not seem to be critical or required by Sonar for correct billing. The RADIUS session will also have in these cases less in and out packets then reported. If this is an issue we can modify ```cleanup.c``` program to check all known cluster members and use the latest data. 

For the ISP management system Sonar to work correctly it needs to see all these radacct table records on a single DB instance. We move all the closed radacct records from the cluster DB servers to a main DB server. Once they are moved we remove them.

We need to only remove the "closed" records. E.g. records that will not be updated by the NASs anymore. Sonar wants to
see the unclosed records also. 

### Current Issues

 1. radacct records are not updated since they are removed. ```Done```
 1. DB replication logs are filling up the docker containers. We need to mount them elsewhere. Or limit size somehow. ```Done```
 1. We need to clean up radacct records that have never been closed. ```Done```
 1. Identical ```acctsessionid``` records may be spread across the DB cluster with only one having the latest data. Since
 these records are copied via an update on the ```acctsessionid``` key old data my replace newer data. ```NotCritical```
 1. We need to restrict authdb-master replication to not include ```radacct``` table. ```BeingResearched```

### Roadmap

 1. Create an Alpine Linux container with MySQL client tools. ```Done```
 1. Create BASH or SH scripts that will gather data and transfer to master DB. ```Done```
 1. Create a libmysql C program that will clean up radacct records fast. ```Done```
 
### Details/Notes

 1. Alpine Linux container will require cron. ```Done```
 1. Will require MySQL client tools and development libs. ```Done```
 1. Can we get BASH installed in Alpine?. Yes. ```Done```
 
 ### Resources
 
 1. https://mariadb.com/kb/en/library/using-and-maintaining-the-binary-log/
 1. https://www.getpagespeed.com/server-setup/mysql-slave-replication
