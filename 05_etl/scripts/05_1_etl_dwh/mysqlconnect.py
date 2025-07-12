# This program requires the python module mysql-connector-python to be installed.
# Install it using the below command
# pip3 install mysql-connector-python

import mysql.connector

# Connect to MySQL
connection = mysql.connector.connect(
    user='YOUR_MYSQL_USER', 
    password='YOUR_MYSQL_PASSWORD',
    host='YOUR_MYSQL_HOST',
    database='YOUR_MYSQL_DATABASE'
)

# Create MySQL cursor
cursor = connection.cursor()

# Create table
SQL = """CREATE TABLE IF NOT EXISTS products(

rowid int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
product varchar(255) NOT NULL,
category varchar(255) NOT NULL

)"""

cursor.execute(SQL)

print("Table created")

# Insert data
SQL = """INSERT INTO products(product,category)
	 VALUES
	 ("Television","Electronics"),
	 ("Laptop","Electronics"),
	 ("Mobile","Electronics")
	 """

cursor.execute(SQL)
connection.commit()


# Query data
SQL = "SELECT * FROM products"

cursor.execute(SQL)

for row in cursor.fetchall():
	print(row)

# Close connection
connection.close()