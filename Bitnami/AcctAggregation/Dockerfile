FROM alpine:3.6

RUN apk add --no-cache dcron bash gawk sed grep bc coreutils libc6-compat mysql-client mysql-dev bind-tools

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
ADD config.slaves.sh /config.slaves.sh
ADD remove-closed.sh /remove-closed.sh
ADD purge-binary.sh /purge-binary.sh

ADD bashrc /root/.bashrc

ADD cleanup /root/cleanup

#private repo version:
#	docker build -t docker0.unxs.io:5000/aggregate:dev .
#	docker push docker0.unxs.io:5000/aggregate:dev
