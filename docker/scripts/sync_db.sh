#!/bin/bash

# Database credentials
DEV_DB_HOST=${DEV_DB_HOST}
DEV_DB_USER=${DEV_DB_USER}
DEV_DB_PASSWORD=${DEV_DB_PASSWORD}
DEV_DB_NAME=${MYSQL_DATABASE}

LOCAL_DB_HOST=${LOCAL_DB_HOST}
LOCAL_DB_USER=${LOCAL_DB_USER}
LOCAL_DB_PASSWORD=${LOCAL_DB_PASSWORD}
LOCAL_DB_NAME=${MYSQL_DATABASE}

# Define sensitive tables to be excluded from synchronization
EXCLUDE_TABLES=(
  "ps_orders" "ps_order_detail" "ps_customer" "ps_address" "ps_guest" "ps_message"
  "ps_log" "ps_connections" "ps_connections_page" "ps_connections_source"
  "ps_customer_message" "ps_customer_thread" "ps_mail" "ps_employee"
)

# Generate exclude list for mysqldump
EXCLUDE_LIST=""
for TABLE in "${EXCLUDE_TABLES[@]}"; do
    EXCLUDE_LIST+=" --ignore-table=${DEV_DB_NAME}.${TABLE}"
done

# Export development database excluding sensitive data
docker exec -i ${PROJECT_NAME}_db mysqldump -h ${DEV_DB_HOST} -u ${DEV_DB_USER} -p${DEV_DB_PASSWORD} ${DEV_DB_NAME} ${EXCLUDE_LIST} > dev_dump.sql

# Import the dump to the local database
docker exec -i ${PROJECT_NAME}_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} < dev_dump.sql

# Update the ps_shop_url table to match the local environment
LOCAL_URL=${LOCAL_URL}
docker exec -i ${PROJECT_NAME}_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} -e "UPDATE ps_shop_url SET domain='localhost', domain_ssl='localhost', physical_uri='/' WHERE id_shop_url=1;"

# Clean up
rm dev_dump.sql
