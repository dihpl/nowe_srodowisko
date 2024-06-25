tabase credentials
DEV_DB_HOST="dev_db_host"
DEV_DB_USER="dev_db_user"
DEV_DB_PASSWORD="dev_db_password"
DEV_DB_NAME="prestashop"

LOCAL_DB_HOST="localhost"
LOCAL_DB_USER="local_db_user"
LOCAL_DB_PASSWORD="local_db_password"
LOCAL_DB_NAME="prestashop"

# Define sensitive tables to be excluded from synchronization
EXCLUDE_TABLES=("ps_orders" "ps_customers" "ps_addresses" "ps_guests" "ps_messages" "ps_logs" "ps_connections")

# Generate exclude list for mysqldump
EXCLUDE_LIST=""
for TABLE in "${EXCLUDE_TABLES[@]}"; do
    EXCLUDE_LIST+=" --ignore-table=${DEV_DB_NAME}.${TABLE}"
done

# Export development database excluding sensitive data
docker exec -i prestashop_db mysqldump -h ${DEV_DB_HOST} -u ${DEV_DB_USER} -p${DEV_DB_PASSWORD} ${DEV_DB_NAME} ${EXCLUDE_LIST} > dev_dump.sql

# Import the dump to the local database
docker exec -i prestashop_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} < dev_dump.sql

# Update the ps_shop_url table to match the local environment
LOCAL_URL="http://localhost:8080"
docker exec -i prestashop_db mysql -h ${LOCAL_DB_HOST} -u ${LOCAL_DB_USER} -p${LOCAL_DB_PASSWORD} ${LOCAL_DB_NAME} -e "UPDATE ps_shop_url SET domain='localhost', domain_ssl='localhost', physical_uri='/' WHERE id_shop_url=1;"

# Clean up
rm dev_dump.sql

Echo "Database synchronized successfully."
