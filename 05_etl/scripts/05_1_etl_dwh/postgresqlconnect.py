# This program requires the python module ibm-db to be installed.
# Install it using the below command
# python3 -m pip install psycopg2

import psycopg2

# Create connection
conn = psycopg2.connect(
    database='YOUR_POSTGRES_DATABASE', 
    user='YOUR_POSTGRES_USER',
    password='YOUR_POSTGRES_PASSWORD',
    host='YOUR_POSTGRES_HOST', 
    port=YOUR_POSTGRES_PORT
)

# Create a cursor onject using cursor() method
cursor = conn.cursor()

# Create table
SQL = """CREATE TABLE IF NOT EXISTS products(rowid INTEGER PRIMARY KEY NOT NULL,product varchar(255) NOT NULL,category varchar(255) NOT NULL)"""

# Execute the SQL statement
cursor.execute(SQL)

print("products Table created")

# Insert data
cursor.execute("INSERT INTO  products(rowid,product,category) VALUES(1,'Television','Electronics')");

cursor.execute("INSERT INTO  products(rowid,product,category) VALUES(2,'Laptop','Electronics')");

cursor.execute("INSERT INTO products(rowid,product,category) VALUES(3,'Mobile','Electronics')");

conn.commit()

# Insert list of Records
list_of_records =[(5,'Mobile','Electronics'),(6,'Mobile','Electronics')]

cursor = conn.cursor()

for row in list_of_records:
  
   SQL="INSERT INTO products(rowid,product,category) values(%s,%s,%s)" 
   cursor.execute(SQL,row);
   conn.commit()

# Query data
cursor.execute('SELECT * from products;')
rows = cursor.fetchall()

for row in rows:
    print(row)

# Create sales_data table
SQL = """CREATE TABLE IF NOT EXISTS sales_data (
  rowid int NOT NULL,
  product_id int NOT NULL,
  customer_id int NOT NULL,
  price decimal DEFAULT 0.0 NOT NULL,
  quantity int NOT NULL,
  timeestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);"""

# Execute the SQL statement
cursor.execute(SQL)

print("sales_data Table created")

conn.commit()
conn.close()
