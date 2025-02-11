FROM alpine:latest as ansible

RUN apk add jq git

ADD ./entrypoint.sh /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]