FROM nginx:alpine
MAINTAINER Gary Wallis "docker@unxs.io"

#Add dig for DNS debug
RUN apk update && apk upgrade && \
    apk add --update bind-tools && \
    rm /var/cache/apk/*

#FreeRadius with ENV configured stream section
# E.g.:
# export cUpstreamAuthServers="server1:1812;server2:1812;server3:1812";
# export cUpstreamAcctServers="server7:1813;server8:1813";
COPY ./nginx.conf /etc/nginx/nginx.conf.template
COPY ./stream-config.sh /usr/sbin/stream-config.sh
COPY ./startup.sh /usr/sbin/startup.sh

ENTRYPOINT ["/usr/sbin/startup.sh"]

#test local dev
#	docker build -t nginxfr:dev .
#private repo version:
#	docker build -t docker0.unxs.io:5000/nginxfr:dev .
#	docker push docker0.unxs.io:5000/nginxfr:dev
