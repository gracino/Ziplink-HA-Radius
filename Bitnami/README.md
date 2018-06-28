## Bitnami MariaDB Replication Cluster Testing

The idea here is to see if we can use this image to
startup a cluster with a prepopulated radius db.

### Initial Attempt

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
