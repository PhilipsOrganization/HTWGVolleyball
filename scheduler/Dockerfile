FROM alpine

RUN apk add --no-cache curl

WORKDIR /app/ping

COPY ping.sh .

RUN chmod +x ping.sh

CMD ["/app/ping/ping.sh"]