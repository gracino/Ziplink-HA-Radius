# Other Data Cleanup and Front End DB Maintenance.

The cluster of front end SQL databases that FreeRADIUS uses for AAA need to be 

 1. Maintained regularly for control of log size and other disk usage issues. 
 1. Configured on boot for replication (ignore radacct table replication for example.)
 1. Certain records can be removed that are not required.
 1. Close ```Orphan Session``` records.

## Orphan Sessions

#### Definition
We define Orphan Sessions (OS) as radacct rows with acctupdatetime that are older than 1 hour.



#### Research Queries

List OS:
```
SELECT * FROM `radacct` WHERE acctupdatetime<(DATE_SUB(NOW(),INTERVAL 1 HOUR))
  AND acctstoptime IS NULL;
 ```

Track other user sessions for users with orphan sessions:
```
SELECT * FROM radacct WHERE username IN
  (SELECT username FROM `radacct` WHERE acctupdatetime<(DATE_SUB(NOW(),INTERVAL 1 HOUR))
  AND acctstoptime IS NULL) ORDER BY username,acctstarttime;
```

```
SELECT 
  username,
  acctstarttime,
  acctupdatetime,
  acctstoptime,
  (acctupdatetime<(DATE_SUB(NOW(),INTERVAL 1 HOUR)) AND acctstoptime IS NULL) AS OrphanSession,
  connectinfo_start,
  connectinfo_stop,
  nasipaddress,
  NOW()
FROM radacct WHERE 
  username IN (SELECT username FROM `radacct` WHERE acctupdatetime<(DATE_SUB(NOW(),INTERVAL 1 HOUR))
    AND acctstoptime IS NULL)
ORDER BY username,acctstarttime
```
