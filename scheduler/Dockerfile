FROM alpine

COPY ping.sh /ping.sh
COPY mycron /etc/crontabs/root

RUN chmod +x /ping.sh && \
    touch /var/log/cron.log

CMD crond && tail -f /var/log/cron.log