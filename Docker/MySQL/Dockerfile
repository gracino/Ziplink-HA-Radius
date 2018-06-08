FROM alpine:3.6
MAINTAINER Gary Wallis "docker@unxs.io"

RUN apk update && \
	apk add mysql mysql-client && \
	addgroup mysql mysql && \
	mkdir /scripts && \
	rm -rf /var/cache/apk/*

COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

#FreeRadius
RUN mkdir /etc/FreeRadius
COPY ./schema.sql /etc/FreeRadius/schema.sql

EXPOSE 3306

ENTRYPOINT ["/scripts/startup.sh"]

#test local dev
#	docker build -t mysqlfr:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/mysqlfr:dev .
#	docker push docker0.unxs.io:5000/mysqlfr:dev
