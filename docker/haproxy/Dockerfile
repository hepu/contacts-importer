FROM haproxy:1.8

RUN apt-get update && apt-get install rsyslog -y

COPY haproxy.conf /etc/rsyslog.d
COPY rsyslog.conf /etc/rsyslog.conf
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY docker-entrypoint.sh /

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
