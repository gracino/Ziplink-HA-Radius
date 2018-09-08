FROM alpine:3.6

RUN apk add --no-cache dcron bash gawk sed grep bc coreutils mysql-client mysql-dev bind-tools

ADD entrypoint.sh /

RUN mkdir -p \
    /opt/cron/periodic \
    /opt/cron/crontabs \
    /opt/cron/cronstamps && \
    ln -sf /dev/pts/0 /opt/cron/stdout && \
    ln -sf /dev/pts/0 /opt/cron/stderr

RUN ln -sf /proc/1/fd/1 /var/log/aggregate.log

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron"]

ADD crontab /opt/cron/crontabs/root
ADD aggregate.sh /aggregate.sh
ADD aggregate-sql.sh /aggregate-sql.sh
ADD delete.sh /delete.sh

ADD bashrc /root/.bashrc

#private repo version:
#	docker build -t docker0.unxs.io:5000/aggregate:dev .
#	docker push docker0.unxs.io:5000/aggregate:dev
