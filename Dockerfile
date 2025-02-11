FROM alpine/terragrunt as terraform

RUN apk add jq git

ADD ./entrypoint.sh /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]