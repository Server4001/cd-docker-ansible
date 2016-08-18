#!/bin/ash
# Activate virtual environment.
. /appenv/bin/activate

# Download requirements to build cache.
pip download -d /build -r requirements_test.txt --no-input

# Install application test requirements.
pip install --no-index -f /build -r requirements_test.txt

# Wait for MySQL container to become available
dockerize -wait tcp://$MYSQL_HOST:3306

# Run test.sh arguments.
exec $@
