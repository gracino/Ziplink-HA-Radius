FROM alpine:3.6
MAINTAINER Support Group <docker@unxs.io>

WORKDIR /projects

RUN apk update && apk upgrade && \
    apk add --update bind-tools && \
    rm /var/cache/apk/*


#test local dev
#	docker build -t dnstools:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/dnstools:dev .
#	docker push docker0.unxs.io:5000/dnstools:dev
