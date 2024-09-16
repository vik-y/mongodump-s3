FROM ubuntu:22.04@sha256:965fbcae990b0467ed5657caceaec165018ef44a4d2d46c7cdea80a9dff0d1ea

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    python3 \
    python3-pymongo \
    curl \
    wget \
    awscli

RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.6.1.deb -O /tmp/mongodb-tools.deb && \
    dpkg -i /tmp/mongodb-tools.deb && \
    rm /tmp/mongodb-tools.deb

RUN mkdir /backup

ENV S3_PATH=mongodb AWS_DEFAULT_REGION=us-east-1

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup
COPY mongouri.py /usr/local/bin/mongouri

VOLUME /backup

CMD /usr/local/bin/entrypoint
