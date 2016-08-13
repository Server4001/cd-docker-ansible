#!/bin/ash
# Activate virtual environment.
. /appenv/bin/activate

# Install application test requirements.
pip install -r requirements_test.txt

# Wait for MySQL container to become available
dockerize -wait tcp://$MYSQL_HOST:3306

# Run test.sh arguments.
exec $@
