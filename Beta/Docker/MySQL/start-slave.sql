# For new mysqlmaster0 only!
# need show master status on master to get file and position
#
CHANGE MASTER TO
  MASTER_HOST='mysqlmaster0',
  MASTER_USER='replication_user',
  MASTER_PASSWORD='bigs3cret',
  MASTER_PORT=3306,
  MASTER_LOG_FILE='mysql-bin.000005',
  MASTER_LOG_POS=327,
  MASTER_CONNECT_RETRY=10;
