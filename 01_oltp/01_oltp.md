# 🗃️ **1. Setup OLTP Database Using MySQL**

![Sample OLTP Data](images/sampledata.png)

This phase involves designing, populating, and administering the **OLTP (Online Transaction Processing) database** to store transactional sales data for the e-commerce platform.



## 🎯 **Objectives**

✅ Design the OLTP database schema

✅ Populate the database with sample data

✅ Automate data exports for downstream processes



## 📝 **Database Schema Design**

The OLTP database stores transactional sales data, including:

* **product\_id**
* **customer\_id**
* **price**
* **quantity**
* **timestamp**

👉 Use the provided schema file: [`oltp.sql`](../01_oltp/scripts/oltp.sql)

### **Steps:**

1. **Create the `sales` database:**

```sql
CREATE DATABASE sales;
```

2. **Create the `sales_data` table:**

```sql
mysql> USE sales;
Database changed

mysql> CREATE TABLE sales_data (
    ->     product_id   INT,
    ->     customer_id  INT,
    ->     price        INT,
    ->     quantity     INT,
    ->     timestamp    TIMESTAMP
    -> );
```

3. **Verify table creation:**

```sql
mysql> SHOW TABLES;
+-----------------+
| Tables_in_sales |
+-----------------+
| sales_data      |
+-----------------+

mysql> DESCRIBE sales_data;
+-------------+-----------+------+-----+---------+-------+
| Field       | Type      | Null | Key | Default | Extra |
+-------------+-----------+------+-----+---------+-------+
| product_id  | int       | YES  |     | NULL    |       |
| customer_id | int       | YES  |     | NULL    |       |
| price       | int       | YES  |     | NULL    |       |
| quantity    | int       | YES  |     | NULL    |       |
| timestamp   | timestamp | YES  |     | NULL    |       |
+-------------+-----------+------+-----+---------+-------+
```

## 📥 **Populate the Database**

1. **Download sample data:** [`oltpdata.csv`](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/oltp/oltpdata.csv)

Example rows:

```
6739,76305,230,1,2020-09-05 16:20:03
7460,81008,1455,4,2020-09-05 16:20:04
...
```

2. **Rename CSV file to match the table name for `mysqlimport`:**

```bash
cp /home/project/oltpdata.csv /home/project/sales_data.csv
```

3. **Import the data using `mysqlimport`:**

```bash
sudo mysqlimport \
  --local \
  --fields-terminated-by=',' \
  --fields-enclosed-by='"' \
  --lines-terminated-by='\n' \
  -u root -p sales /home/project/sales_data.csv
```

✅ Expected output:

```
sales.sales_data: Records: 2605  Deleted: 0  Skipped: 0  Warnings: 0
```

4. **Verify import:**

```sql
mysql> SELECT COUNT(*) FROM sales_data;
+----------+
| COUNT(*) |
+----------+
|     2605 |
+----------+

mysql> SELECT * FROM sales_data LIMIT 5;
+------------+-------------+-------+----------+---------------------+
| product_id | customer_id | price | quantity | timestamp           |
+------------+-------------+-------+----------+---------------------+
|       6739 |       76305 |   230 |        1 | 2020-09-05 16:20:03 |
|       7460 |       81008 |  1455 |        4 | 2020-09-05 16:20:04 |
|       6701 |        7556 |  1159 |        2 | 2020-09-05 16:20:05 |
|       8021 |       36492 |  3727 |        2 | 2020-09-05 16:20:06 |
|       6442 |       11282 |  4387 |        5 | 2020-09-05 16:20:07 |
+------------+-------------+-------+----------+---------------------+

```



## ⚙️ **Setup Administration Tasks**

1. **Create an index on the `timestamp` field:**

```sql
CREATE INDEX ts ON sales_data (timestamp);
```

2. **List indexes on `sales_data`:**

```sql
SHOW INDEX FROM sales_data;
```

✅ Example output:

```sql
mysql> SHOW INDEX FROM sales_data;
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table      | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| sales_data |          1 | ts       |            1 | timestamp   | A         |        2605 |     NULL |   NULL | YES  | BTREE      |         |               | YES     | NULL       |
+------------+------------+----------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
```


## 💾 **Automate Data Export**

Create a bash script to export all rows from `sales_data` to a `.sql` file.

### **Script: [`datadump.sh`](../01_oltp/scripts/datadump.sh)**

```bash
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
```

### **Usage:**

1. **Make the script executable:**

```bash
sudo chmod u+x datadump.sh
```

2. **Run the export script:**

```bash
sudo ./datadump.sh
```

✅ Expected output:

```
mysqldump: [Warning] Using a password on the command line interface can be insecure.
Export completed: sales_data.sql
```

The data is exported to [`sales_data.sql`](../01_oltp/data/sales_data.sql).



## 🗂️ **Project Phases**

🔗 **Next Steps:**
1. ✅ Setup OLTP database using MySQL
2. [Setup NoSQL database using MongoDB](../02_nosql/02_nosql.md)
3. [Build Data Warehouse using PostgreSQL](../03_dwh/03_dwh.md)
4. [Create Business Intelligence Dashboard using Tableau](../04_analytics/04_analytics.md)
5. [Create ETL Data Pipelines using Apache Airflow](../05_etl/05_etl.md)
6. [Perform Big Data Analytics with Apache Spark](../06_spark/06_spark.md)
