-- Create sales database
CREATE DATABASE sales;

--Create sales_data table
USE sales;

CREATE TABLE sales_data (
    product_id   INT ,
    customer_id  INT,
    price        INT,
    quantity     INT,
    timestamp    TIMESTAMP
);

-- Import oltpdata.csv to sales_data 

-- List the tables in the database sales
USE sales;
SHOW TABLES;

-- Find the count of sales_data
SELECT COUNT(*) FROM sales_data;

-- Describe sales_data
DESCRIBE sales_data;

-- Create index
CREATE INDEX ts on sales_data(timestamp);

-- List indexes
SHOW INDEX FROM sales.sales_data;
