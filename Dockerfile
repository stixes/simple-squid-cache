FROM alpine:latest

ENV SQUID_CACHE_DIR=/var/cache/squid
ENV SQUID_DISK_SIZE_MB=8192
ENV SQUID_MEM_SIZE_MB=1024

ADD entrypoint.sh /sbin/entrypoint.sh
RUN apk add --no-cache squid gettext && \
    rm -f /etc/squid/squid.conf && \
    chmod 755 /sbin/entrypoint.sh

ADD squid.conf.tmpl /

VOLUME /var/cache/squid
EXPOSE 3128/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
