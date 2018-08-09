FROM alpine:3.8

RUN apk add --no-cache dcron bash gawk sed grep bc coreutils

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

ONBUILD ADD crontab /opt/cron/crontabs/root
