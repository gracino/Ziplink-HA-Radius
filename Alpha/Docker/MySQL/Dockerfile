FROM alpine:3.6
MAINTAINER Gary Wallis "docker@unxs.io"

RUN apk update && \
	apk add mysql mysql-client && \
	addgroup mysql mysql && \
	mkdir /scripts && \
	rm -rf /var/cache/apk/*

RUN set -x && \
	apk add --update libintl && \
	apk add --virtual build_deps gettext &&  \
	cp /usr/bin/envsubst /usr/local/bin/envsubst && \
	apk del build_deps

COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

#FreeRadius
RUN mkdir /etc/FreeRadius
#Configured into schema.sql via startup.sh below
COPY ./schema.sql.template /etc/FreeRadius/schema.sql.template

EXPOSE 3306

ENTRYPOINT ["/scripts/startup.sh"]

#test local dev
#	docker build -t mysqlfr:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/mysqlfr:dev .
#	docker push docker0.unxs.io:5000/mysqlfr:dev
