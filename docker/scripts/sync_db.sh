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

# Define tables to be excluded from data synchronization (only schema will be copied)
SCHEMA_ONLY_TABLES=(
  "admin_filter" "address" "cart" "cart_cart_rule" "cart_product" "connections"
  "connections_page" "connections_source" "customer" "customer_group" "customer_message"
  "customer_message_sync_imap" "customer_session" "customer_thread" "customized_data"
  "emailsubscription" "eventbus_deleted_objects" "eventbus_incremental_sync"
  "eventbus_job" "eventbus_type_sync" "guest" "layered_filter_block" "log" "mail"
  "orders" "order_carrier" "order_cart_rule" "order_detail" "order_detail_tax"
  "order_history" "order_invoice" "order_invoice_payment" "order_invoice_tax"
  "order_message" "order_message_lang" "order_payment" "order_payu_payments"
  "order_payu_payments_history" "order_return" "order_return_detail" "order_slip"
  "order_slip_detail" "order_slip_detail_tax" "pagenotfound" "page_viewed"
  "psgdpr_log" "statssearch"
)

# Generate exclude list for mysqldump
EXCLUDE_DATA_LIST=""
for TABLE in "${SCHEMA_ONLY_TABLES[@]}"; do
    EXCLUDE_DATA_LIST+=" --ignore-table=${DEV_DB_NAME}.${TABLE}"
done

# Export development database excluding data for specified tables
docker exec -i ${PROJECT_NAME}_db mysqldump -h ${DEV_DB_HOST} -u ${DEV_DB_USER} -p${DEV_DB_PASSWORD} ${DEV_DB_NAME} ${EXCLUDE_DATA_LIST} > dev_dump.sql

# Export only the schema for the specified tables
docker exec -i ${PROJECT_NAME}_db mysqldump -h ${DEV_DB_HOST} -u ${DEV_DB_USER} -p${DEV_DB_PASSWORD} --no-data ${DEV_DB_NAME} ${SCHEMA_ONLY_TABLES[@]} >> dev_dump.sql

# Import the dump to the local database
docker exec -i ${PROJECT_NAME}_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} < dev_dump.sql

# Update the ps_shop_url table to match the local environment
LOCAL_URL=${LOCAL_URL}
docker exec -i ${PROJECT_NAME}_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} -e "UPDATE ps_shop_url SET domain='localhost', domain_ssl='localhost', physical_uri='/' WHERE id_shop_url=1;"

# Clean up
rm dev_dump.sql
