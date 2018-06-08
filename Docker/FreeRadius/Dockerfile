#Basic building block for docker-compose HA FreeRadius
#cluster with nginx udp reverse proxy, replicated 
#and sharded. Centrally MySQL configured and agregated back into central
#Sonar controlled mySQL instance.

FROM alpine:3.6
MAINTAINER Support Group <docker@unxs.io>

WORKDIR /projects

RUN apk update && apk upgrade && \
    apk add --update freeradius freeradius-mysql freeradius-radclient openssl-dev && \
    chgrp radius  /usr/sbin/radiusd && chmod g+rwx /usr/sbin/radiusd && \
    rm /var/cache/apk/*

#Setup for MySQL
RUN cd /etc/raddb/mods-enabled; ln -s ../mods-available/sql sql;
COPY ./etc/raddb/mods-available/sql /etc/raddb/mods-available/sql
#We will not be using the EAP/PEAP inner-tunnel
RUN rm /etc/raddb/sites-enabled/inner-tunnel;
#Our specific config
COPY ./etc/raddb/sites-available/default /etc/raddb/sites-available/default

#Does not have inner-tunnel tcp port
EXPOSE 1812/udp 1813/udp

#CMD ["radiusd","-xx","-f"]
#debug mode
CMD ["radiusd","-X","-f"]

#test local dev
#	docker build -t freeradius:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/freeradius:dev .
#	docker push docker0.unxs.io:5000/freeradius:dev
