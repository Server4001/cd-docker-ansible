FROM server4001/todobackend-base:0.2.0

MAINTAINER Brice Bentler <me@bricebentler.com>

# Install dev/build dependencies.
RUN apk add --update \
    python-dev \
    mariadb-dev

# Activate virtual environment and install wheel support.
RUN . /appenv/bin/activate && \
    pip install wheel --upgrade

# PIP environment variables (NOTE: must be set AFTER installing wheel).
ENV WHEELHOUSE=/wheelhouse PIP_WHEEL_DIR=/wheelhouse PIP_FIND_LINKS=/wheelhouse XDG_CACHE_HOME=/cache

# OUTPUT: Build artifacts (Wheels) are output here.
VOLUME /wheelhouse

# OUTPUT: Test reports are output here.
VOLUME /reports

# Add test entrypoint script.
COPY docker/dev/scripts/test.sh /usr/local/bin/test.sh
RUN chmod +x /usr/local/bin/test.sh

# Add dockerize, for waiting on service availability.
COPY docker/dev/scripts/dockerize-linux-amd64-v0.2.0.tar.gz /usr/lib/dockerize-linux-amd64-v0.2.0.tar.gz
RUN tar -C /usr/local/bin -xzvf /usr/lib/dockerize-linux-amd64-v0.2.0.tar.gz && rm /usr/lib/dockerize-linux-amd64-v0.2.0.tar.gz

# Set defaults for entrypoint and command string.
ENTRYPOINT ["test.sh"]
CMD ["python", "manage.py", "test", "--noinput"]

# Add application source.
COPY src /application
WORKDIR /application
