FROM alpine:3.18

MAINTAINER Leonardo Gatica <lgatica@protonmail.com>

RUN apk add --no-cache mongodb-tools=100.7.0-r3 py3-pip python3 curl && \
  pip install awscli && \
  mkdir /backup

ENV S3_PATH=mongodb AWS_DEFAULT_REGION=us-east-1

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup

VOLUME /backup

CMD /usr/local/bin/entrypoint
