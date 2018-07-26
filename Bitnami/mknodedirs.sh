#!/bin/bash

#      - /data/authdb-master/bitnami:/bitnami
#      - /data/acctdb-master/bitnami:/bitnami
#      - /data/authdb-setup/auth-start.sh:/usr/local/sbin/start.sh
#      - /data/authdb-setup/auth-setup.sql:/tmp/setup.sql
#      - /data/acctdb-setup/acct-start.sh:/usr/local/sbin/start.sh
#      - /data/acctdb-setup/acct-setup.sql:/tmp/setup.sql
#      - /data/letsencrypt:/etc/letsencrypt
#      - /data/nginx/html:/usr/share/nginx/html
#      - /data/phpmyadmin/nginx.conf:/etc/nginx.conf
#      - /data/freeradius/clients.conf:/etc/raddb/clients.conf
#      - /data/freeradius/users:/etc/raddb/users

if [ "$2" == "--deleteall" ];then
	rm -rf /data/
fi

mkdir -p /data/authdb-master/bitnami
chmod 775 /data/authdb-master/bitnami


mkdir -p /data/acctdb-master/bitnami
chmod 775 /data/acctdb-master/bitnami

mkdir -p /data/authdb-setup

if [ "$1" != "--nofiles" ];then
	cp -i ./auth-start.sh /data/authdb-setup/
	cp -i ./auth-setup.sql /data/authdb-setup/
fi

mkdir -p /data/acctdb-setup
if [ "$1" != "--nofiles" ];then
	cp -i ./acct-start.sh /data/acctdb-setup/
	cp -i ./acct-setup.sql /data/acctdb-setup/
fi

mkdir -p /data/letsencrypt
#populated by ssl scripts

mkdir -p /data/nginx/html

mkdir -p /data/phpmyadmin
if [ "$1" != "--nofiles" ];then
	cp -i ./nginx.conf /data/phpmyadmin/
fi

mkdir -p /data/freeradius
if [ "$1" != "--nofiles" ];then
	cp -i ./clients.conf  /data/freeradius/
	cp -i ./users  /data/freeradius/
fi
