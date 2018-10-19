FROM docker0.unxs.io:5000/freeradius:dev
MAINTAINER Support Group <docker@unxs.io>

#special start up script that waits for mysql.
COPY ./start.sh /usr/sbin/start.sh

#test local dev
#	docker build -t freeradius:debug .
#private repo version:
#	docker build -t docker0.unxs.io:5000/freeradius:debug .
#	docker push docker0.unxs.io:5000/freeradius:debug
