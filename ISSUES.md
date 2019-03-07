## Current Issues 
Current issues that need to be resolved.

### Accounting Aggregation
#### NASs Need to Update Records
The current aggregation code moves everything to the ```authdb-master```,
we need to only move "closed" ```radacct``` table records. 

### Server Maintenance

#### Node crontab

```
[root@Radius-secondary ~]# crontab -l
#zap large docker mysqld.log files
17 * * * *  /usr/local/sbin/clean-mysqld.log.sh > /dev/null 2>&1;
#zap radius.log's daily
40 4 * * *  /usr/local/sbin/clean-radius.log.sh > /dev/null 2>&1;
#keep tasks.db in control
#20 2 * * * service docker stop > /dev/null;rm /var/lib/docker/swarm/worker/tasks.db;service docker start > /dev/null;

```

#### tasks.db
The secondary node had a huge ```/var/lib/docker/swarm/worker/tasks.db```

This fixes it:

```
# service docker stop
# rm /var/lib/docker/swarm/worker/tasks.db
# service docker start
```

#### Logs

We need to keep non ext volume containers like ```radiuscluster_acctdb-slave``` from taking up scarce disk resources.

By configuring replication logging some of this should be under control. 
The mysqld.log is the reminaing issue. This could be done at the server level zapping them daily with /dev/null.

```
[root@Radius-secondary ~]# find / -size +500M
/proc/kcore
find: ‘/proc/11519/task/11519/fd/5’: No such file or directory
find: ‘/proc/11519/task/11519/fdinfo/5’: No such file or directory
find: ‘/proc/11519/fd/6’: No such file or directory
find: ‘/proc/11519/fdinfo/6’: No such file or directory
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/diff/bitnami/mariadb/data/mysql-bin.000002
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/diff/bitnami/mariadb/data/mysql-bin.000003
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/diff/bitnami/mariadb/data/mysql-bin.000004
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/diff/bitnami/mariadb/data/mysql-bin.000005
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/merged/bitnami/mariadb/data/mysql-bin.000002
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/merged/bitnami/mariadb/data/mysql-bin.000003
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/merged/bitnami/mariadb/data/mysql-bin.000004
/var/lib/docker/overlay2/f8995fc8bf131459b5bbca8ab3148383fa911cd53fd62524fe92688378f772a2/merged/bitnami/mariadb/data/mysql-bin.000005
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/diff/opt/bitnami/mariadb/logs/mysqld.log
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/diff/bitnami/mariadb/data/mysql-bin.000002
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/diff/bitnami/mariadb/data/mysql-bin.000003
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/merged/opt/bitnami/mariadb/logs/mysqld.log
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/merged/bitnami/mariadb/data/mysql-bin.000002
/var/lib/docker/overlay2/c4000ebae72396030a576c59cb510d70fa85185fb7fb2d1f22923d1a6c669ec7/merged/bitnami/mariadb/data/mysql-bin.000003
```
