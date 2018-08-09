FROM alpine:3.6

RUN apk add --no-cache dcron bash gawk sed grep bc coreutils mysql-client bind-tools

ADD execute /usr/bin/
ADD entrypoint.sh /

RUN mkdir -p \
    /opt/cron/periodic \
    /opt/cron/crontabs \
    /opt/cron/cronstamps && \
    ln -sf /dev/pts/0 /opt/cron/stdout && \
    ln -sf /dev/pts/0 /opt/cron/stderr

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron"]

ADD crontab /opt/cron/crontabs/root
ADD aggregate.sh /aggregate.sh

#private repo version:
#	docker build -t docker0.unxs.io:5000/aggregate:dev .
#	docker push docker0.unxs.io:5000/aggregate:dev
