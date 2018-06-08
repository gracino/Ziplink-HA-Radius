#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo -n 'MySQL directory already present, skipping creation'
else
	echo -n "MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	# init database
	echo -n 'Initializing Database'
	mysql_install_db --user=mysql
	echo -n 'Database Initialized'

	# Create FreeRadius schema
	echo -n "Creating FreeRadius Schema via schema.sql"
	/usr/bin/mysqld --user=mysql --bootstrap < /etc/FreeRadius/schema.sql;
fi

echo -n "Sleeping 5 sec"
sleep 5

echo -n 'Start running mysqld'
exec /usr/bin/mysqld --user=mysql --console
