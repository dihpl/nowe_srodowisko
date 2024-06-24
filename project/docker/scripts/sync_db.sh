#!/bin/bash

# Define sensitive tables to be excluded from synchronization
EXCLUDE_TABLES=("orders" "customers" "addresses" "guests" "messages" "logs" "connections")

# Generate exclude list for mysqldump
EXCLUDE_LIST=""
for TABLE in "${EXCLUDE_TABLES[@]}"; do
    EXCLUDE_LIST+=" --ignore-table=prestashop.${TABLE}"
done

# Export production database excluding sensitive data
mysqldump -h production_db_host -u production_db_user -p production_db_password prestashop ${EXCLUDE_LIST} > prod_dump.sql

# Import the dump to the development/local database
mysql -h local_db_host -u local_db_user -p local_db_password prestashop < prod_dump.sql
