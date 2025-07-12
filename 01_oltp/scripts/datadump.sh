#!/bin/bash

# Database credentials
DB_USER="YOUR_MYSQL_USER"
DB_PASSWORD="YOUR_MYSQL_PASSWORD"
DB_NAME="sales"
TABLE_NAME="sales_data"
OUTPUT_FILE="sales_data.sql"

# Export the table
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" "$TABLE_NAME" > "$OUTPUT_FILE"

# Check export status
if [ $? -eq 0 ]; then
    echo "Export completed: $OUTPUT_FILE"
else
    echo "Export failed"
fi
