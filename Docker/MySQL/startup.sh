#!/bin/sh

#Provide defaults
if [ "$cMysqlLogin" == "" ];then
	cMysqlLogin="radius";
fi
if [ "$cMysqlPassword" == "" ];then
	cMysqlPassword="lksjdf78498kdfjh";
fi

envsubst '${cMysqlLogin},${cMysqlPassword}' < /etc/FreeRadius/schema.sql.template > /etc/FreeRadius/schema.sql;

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo -n '[i] MySQL directory already present, skipping creation'
else
	echo -n "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	# init database
	echo -n '[i] Initializing Database'
	mysql_install_db --user=mysql
	echo -n '[i] Database Initialized'

	# Create FreeRadius schema
	echo -n "[i] Creating FreeRadius schema and mysql user,db,tables_priv via schema.sql"
	/usr/bin/mysqld --user=mysql --bootstrap < /etc/FreeRadius/schema.sql;
fi

echo -n "[i] Sleeping 5 sec"
sleep 5

echo -n '[i] Start running mysqld'
exec /usr/bin/mysqld --user=mysql --console
