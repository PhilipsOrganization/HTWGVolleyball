FROM alpine

RUN apk add --no-cache curl

COPY ping.sh /ping.sh

RUN chmod +x /ping.sh

CMD ["/ping.sh"]