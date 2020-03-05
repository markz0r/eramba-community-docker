#!/bin/bash
DB_CONTAINER_NAME="eramba-community-docker_db_1"
#DB_SCHEMA_SCRIPT="./sql/c2.4.1.sql"
DB_SCHEMA_SCRIPT="./sql/c2.8.1.sql"

docker exec -i ${DB_CONTAINER_NAME} sh -c \
    'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"' < ${DB_SCHEMA_SCRIPT}
