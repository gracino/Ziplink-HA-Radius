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

VOLUME \
    /opt/db/ \
    /etc/freeradius/certs

EXPOSE \
    1812/udp \
    1813/udp \
    18120

CMD ["radiusd","-xx","-f"]

#test local dev
#	docker build -t freeradius:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/freeradius:dev .
#	docker push docker0.unxs.io:5000/freeradius:dev
