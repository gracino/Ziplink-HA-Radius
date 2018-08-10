#!/bin/bash

if [ "$1" == "" ];then
        echo "usage: $0 <Host cIPNumber>";
        exit 0;
fi
if [ "$cMysqlLogin" == "" ];then
        exit 2;
fi
if [ "$cMysqlPassword" == "" ];then
        exit 3;
fi



#timestamp
cToday=`date +%Y%m%d%H%M`

#lock and dump
/usr/bin/mysqldump --no-create-db --no-create-info --lock-tables -h $1 -u$cMysqlLogin -p$cMysqlPassword \
        radius radacct > /tmp/radacct.$1.mysqldump.$cToday;
if [ "$?" == "0" ];then
        /usr/bin/mysql -h authdb-master -p$cMysqlPassword -u$cMysqlLogin < /tmp/radacct.$1.mysqldump.$cToday"
        if [ "$?" == "0" ];then              
                rm /tmp/radacct.$1.mysqldump.$cToday;
                exit 0;
        else                       
                echo "mysql $1 insert into authdb-master failed!";
                exit 4;            
        fi                         
else           
        echo "mysqldump $1 failed!";
        exit 1;
fi
