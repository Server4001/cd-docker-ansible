FROM alpine:3.4

MAINTAINER Brice Bentler <me@bricebentler.com>

RUN apk add --update \
    python \
    py-pip \
    build-base \
&& pip install virtualenv \
&& rm -rf /var/cache/apk/*

RUN virtualenv /appenv && \
    . /appenv/bin/activate && \
    pip install pip --upgrade

ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
