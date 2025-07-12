# Import libraries to enrich data
from datetime import datetime

# Import libraries required for connecting to MySQL
import mysql.connector

# Import libraries required for connecting to PostgreSQL
import psycopg2

# Connect to MySQL
mysql_conn = mysql.connector.connect(
    user='YOUR_MYSQL_USER', 
    password='YOUR_MYSQL_PASSWORD',
    host='YOUR_MYSQL_HOST',
    database='YOUR_MYSQL_DATABASE'
)

# Create MySQL cursor
mysql_cursor = mysql_conn.cursor()

# Connect to PostgreSQL
postgres_conn = psycopg2.connect(
    database='YOUR_POSTGRES_DATABASE', 
    user='YOUR_POSTGRES_USER',
    password='YOUR_POSTGRES_PASSWORD',
    host='YOUR_POSTGRES_HOST', 
    port=YOUR_POSTGRES_PORT
)

# Create PostgreSQL cursor 
postgres_cursor = postgres_conn.cursor()

# Find out the last rowid from PostgreSQL data warehouse
def get_last_rowid():
    """Return the last rowid of the table sales_data in the sales database on the PostgreSQL production data warehouse
    """
    last_rowid_query = """SELECT MAX(rowid) FROM sales_data;"""
    postgres_cursor.execute(last_rowid_query)
    result = postgres_cursor.fetchone()
    return result[0] if result[0] is not None else 0

last_row_id = get_last_rowid()
print("Last row id on production data warehouse = ", last_row_id)

# List out all records in MySQL database with rowid greater than the one on the PostgreSQL data warehouse
def get_latest_records(rowid):
    """Return a list of all records that have a rowid greater than the last_row_id in the sales_data table in the sales database on the MySQL staging data warehouse.
    """
    mysql_cursor.execute(
        "SELECT rowid, product_id, customer_id, quantity FROM sales_data WHERE rowid > %s;",
        (rowid,)
    )
    records = mysql_cursor.fetchall()
    return records

new_records = get_latest_records(last_row_id)
print("New rows on staging data warehouse = ", len(new_records))

# Insert the additional records from MySQL into PostgreSQL data warehouse.
def insert_records(records):
    """Insert all the records passed to it into the sales_data table in the sales database on the PostgreSQL production data warehouse
    """
    if not records:
        print("No new records to insert.")
        return
    
    # Add default values for price and timestamp
    enriched_records = [(r[0], r[1], r[2], 0.0, r[3], datetime.now()) for r in records]
    
    insert_query = """
        INSERT INTO sales_data (rowid, product_id, customer_id, price, quantity, timeestamp)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    postgres_cursor.executemany(insert_query, enriched_records)
    postgres_conn.commit()

insert_records(new_records)
print("New rows inserted into production data warehouse = ", len(new_records))

# Disconnect from MySQL data warehouse
mysql_cursor.close()
mysql_conn.close()

# Disconnect from PostgreSQL data warehouse 
postgres_cursor.close()
postgres_conn.close()
