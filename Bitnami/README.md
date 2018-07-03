## Bitnami MariaDB Replication Cluster Testing

The idea here is to see if we can use this image to
startup a cluster with a prepopulated radius DB.

### Swarm Cluster

After the initial tests we have created a three node swarm cluster and
have deployed a replicated DB backend using ```dbcluster.yml```.

Here is the current result:

```
[root@docker3 Bitnami]# docker stack ps dbcluster
ID                  NAME                         IMAGE                    NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
fvys1zuopbrh        dbcluster_mariadb-master.1   bitnami/mariadb:latest   docker3             Running             Running 3 minutes ago                        
oss0daqkon9h        dbcluster_mariadb-setup.1    bitnami/mariadb:latest   docker3             Shutdown            Complete 2 minutes ago                       
w563kbcuroe8        dbcluster_mariadb-slave.1    bitnami/mariadb:latest   docker0             Running             Running 3 minutes ago                        
5252y02iiubi        dbcluster_mariadb-slave.2    bitnami/mariadb:latest   docker1             Running             Running 3 minutes ago                        
```

Test results:

```
[root@docker3 Bitnami]# docker exec -ti bc95795437e4 mysql -h dbcluster_mariadb-master -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
[root@docker3 Bitnami]# docker exec -ti bc95795437e4 mysql -h dbcluster_mariadb-slave -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+

```

Per node tests:

```
[root@docker0 vagrant]# docker exec -ti f349a3d2b07f mysql -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+

```

```
[root@docker1 vagrant]# docker exec -ti 16a1c20ff6bd mysql -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+

```


### Initial Attempt Version 2 docker-compose

We will try to use a helper container to load the master after it
starts up.

Then we can run tests to see if the data is available cluster wide.

### Works Fine

The setup helper container waits for the master to be ready then it configures the radius db.

If you start the cluster again with persistent data volume the helper container quits fine
not messing anything up.

### Example start with empty db data in master

```
[root@c7docker Bitnami]# docker-compose up -d
Creating network "bitnami_default" with the default driver
Creating bitnami_mariadb-master_1 ... 
Creating bitnami_mariadb-master_1 ... done
Creating bitnami_mariadb-slave_1 ... 
Creating bitnami_mariadb-slave_1 ... done
Creating bitnami_mariadb-setup_1 ... 
Creating bitnami_mariadb-setup_1 ... done
[root@c7docker Bitnami]# dc ps
          Name                        Command               State            Ports          
-------------------------------------------------------------------------------------------
bitnami_mariadb-master_1   /app-entrypoint.sh /run.sh       Up      0.0.0.0:32786->3306/tcp 
bitnami_mariadb-setup_1    /app-entrypoint.sh /usr/lo ...   Up      3306/tcp                
bitnami_mariadb-slave_1    /app-entrypoint.sh /run.sh       Up      0.0.0.0:32787->3306/tcp 
[root@c7docker Bitnami]# docker logs bitnami_mariadb-setup_1

Welcome to the Bitnami mariadb container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-mariadb
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-mariadb/issues

ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
[root@c7docker Bitnami]# docker logs bitnami_mariadb-setup_1

Welcome to the Bitnami mariadb container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-mariadb
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-mariadb/issues

ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
ERROR 2003 (HY000): Can't connect to MySQL server on 'mariadb-master' (111 "Connection refused")
Waiting for MySQL
[root@c7docker Bitnami]# dc ps
          Name                        Command               State             Ports          
--------------------------------------------------------------------------------------------
bitnami_mariadb-master_1   /app-entrypoint.sh /run.sh       Up       0.0.0.0:32786->3306/tcp 
bitnami_mariadb-setup_1    /app-entrypoint.sh /usr/lo ...   Exit 0                           
bitnami_mariadb-slave_1    /app-entrypoint.sh /run.sh       Up       0.0.0.0:32787->3306/tcp 
[root@c7docker Bitnami]# docker exec -ti bitnami_mariadb-master_1 mysql -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
[root@c7docker Bitnami]# docker exec -ti bitnami_mariadb-slave_1 mysql -uradius -pradiuspasswd radius -e 'select * from nas'
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
| id | nasname        | shortname   | type  | ports | secret           | server | community | description                               |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+
|  1 | 71.42.155.65   | HAS         | other |  NULL | j2qksrv0hsiwnm6v | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  2 | 67.79.11.167   | AlconOffice | other |  NULL | eyr1u3gowkgfn60g | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  3 | 104.218.76.65  | SDWT        | other |  NULL | kcesnjdmllzndx0s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  4 | 38.103.213.193 | PICOSA      | other |  NULL | z22k53nd9m3cdv5f | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  5 | 104.218.77.161 | CCR181      | other |  NULL | 5fm0ubmb82a0jhws | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  6 | 71.40.111.65   | SLAV        | other |  NULL | ijb0k4fnhke4wwef | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
|  9 | 71.40.111.145  | WYNN        | other |  NULL | 9u1fgljb1qi8pj1s | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 11 | 71.42.155.97   | OHWT        | other |  NULL | x54u090de2th0qym | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 12 | 38.103.213.225 | BeckmanMP   | other |  NULL | kg3j4c4ri8wd5v02 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 13 | 148.59.236.129 | Trailcrest  | other |  NULL | by358k7wn4zoju4c | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 15 | 71.40.111.177  | Bynum       | other |  NULL | 54ykrjzc9w9mjfyx | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 16 | 71.40.111.217  | POTH        | other |  NULL | g9wvvp5uhnszs6ir | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 17 | 71.40.111.241  | SBA         | other |  NULL | gx1ulbvseumwyoes | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 18 | 71.40.111.97   | Ksat        | other |  NULL | 9dh11yxa399rehg0 | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 19 | 71.40.111.161  | RUMC        | other |  NULL | 819dh05g3g4q2smr | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 20 | 71.40.111.33   | GRAMS       | other |  NULL | rcpwv0ckc4c08w8d | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
| 21 | 71.40.111.1    | FVtwr       | other |  NULL | l4lilowurr63zuvm | NULL   | NULL      | Added via the Sonar FreeRADIUS Genie tool |
+----+----------------+-------------+-------+-------+------------------+--------+-----------+-------------------------------------------+

```

### Verify DNS Round Robin for Scaled-Up Services

We created a simple Dockerfile for Alpine bind-tools so we can check to make sure
that docker-compose service discovery is working as expected. It is.

This should allow us to scale up MySQL servers without changing Nginx configuration.

See Nginx server directive w/resolver and resolve parameter.


```
[root@c7docker Bitnami]# docker-compose scale mariadb-slave=2
Starting bitnami_mariadb-slave_1 ... done
Creating bitnami_mariadb-slave_2 ... 
Creating bitnami_mariadb-slave_2 ... done
[root@c7docker Bitnami]# docker-compose ps
          Name                        Command               State             Ports          
--------------------------------------------------------------------------------------------
bitnami_dnstools_1         dig mariadb-slave                Exit 0                           
bitnami_mariadb-master_1   /app-entrypoint.sh /run.sh       Up       0.0.0.0:32788->3306/tcp 
bitnami_mariadb-setup_1    /app-entrypoint.sh /usr/lo ...   Exit 1                           
bitnami_mariadb-slave_1    /app-entrypoint.sh /run.sh       Up       0.0.0.0:32789->3306/tcp 
bitnami_mariadb-slave_2    /app-entrypoint.sh /run.sh       Up       0.0.0.0:32792->3306/tcp 

```

```
[root@c7docker Bitnami]# docker-compose run dnstools

; <<>> DiG 9.11.3 <<>> mariadb-slave
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56852
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;mariadb-slave.			IN	A

;; ANSWER SECTION:
mariadb-slave.		600	IN	A	172.18.0.4
mariadb-slave.		600	IN	A	172.18.0.3

;; Query time: 0 msec
;; SERVER: 127.0.0.11#53(127.0.0.11)
;; WHEN: Sat Jun 30 13:31:08 UTC 2018
;; MSG SIZE  rcvd: 89

```
