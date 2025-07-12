-- DimDate Table
SELECT * FROM "DimDate" LIMIT 5;
SELECT COUNT(*) FROM "DimDate";

-- DimCategory Table
SELECT * FROM "DimCategory";
SELECT COUNT(*) FROM "DimCategory";

-- DimCountry Table
SELECT * FROM "DimCountry" LIMIT 5;
SELECT COUNT(*) FROM "DimCountry";

-- FactSales Table
SELECT * FROM "FactSales" LIMIT 5;
SELECT COUNT(*) FROM "FactSales";


-- Total Sales

SELECT SUM(amount) AS total_sales FROM "FactSales";

-- Top Categories**

SELECT 
    cat.category, 
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimCategory" cat ON fs.categoryid = cat.categoryid
GROUP BY 
    cat.category
ORDER BY 
    total_sales DESC;

-- Top Countries

SELECT 
    dc.country, 
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    dc.country
ORDER BY 
    total_sales DESC;

-- Top Months

SELECT 
    dd."Monthname", 
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
GROUP BY 
    dd."Monthname"
ORDER BY 
    total_sales DESC;

-- Top Quarters

SELECT 
    dd."QuarterName", 
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
GROUP BY 
    dd."QuarterName"
ORDER BY 
    total_sales DESC;

-- Top Years

SELECT 
    dd."Year", 
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
GROUP BY 
    dd."Year"
ORDER BY 
    total_sales DESC;


-- Create a grouping sets query using the columns `country`, `category`, `total_sales`.

SELECT 
    dc.country,
    cat.category,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
JOIN 
    "DimCategory" cat ON fs.categoryid = cat.categoryid
GROUP BY 
    GROUPING SETS (
        (dc.country, cat.category),
        (dc.country),
        (cat.category),
        ()
    )
ORDER BY 
    total_sales DESC;

-- Create a cube query using the columns `"Year"`, `country`, and `average sales`.

SELECT 
    dd."Year",
    dc.country,
    AVG(fs.amount) AS avg_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    CUBE (dd."Year", dc.country)
ORDER BY 
    dd."Year", avg_sales DESC;

-- Create Materialized Query Table (MQT) for **total sales per country** for fast retrieval.


CREATE MATERIALIZED VIEW total_sales_per_country AS
SELECT 
    dc.country,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    dc.country;

SELECT * FROM total_sales_per_country 
ORDER BY total_sales DESC;

-- Total sales per year per country

SELECT 
    dd."Year",
    dc.country,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    ROLLUP (dd."Year", dc.country)
ORDER BY 
    dd."Year", total_sales DESC;

-- Total sales per month per category

SELECT 
    dd."Monthname",
    cat.category,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
JOIN 
    "DimCategory" cat ON fs.categoryid = cat.categoryid
GROUP BY 
    ROLLUP (dd."Month", dd."Monthname", cat.category)
ORDER BY 
    dd."Month", total_sales DESC;

-- Total sales per quarter per country

SELECT 
    dd."QuarterName",
    dc.country,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimDate" dd ON fs.dateid = dd.dateid
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    ROLLUP (dd."QuarterName", dc.country)
ORDER BY 
    dd."QuarterName", total_sales DESC;

-- Total sales per category per country

SELECT 
    cat.category,
    dc.country,
    SUM(fs.amount) AS total_sales
FROM 
    "FactSales" fs
JOIN 
    "DimCategory" cat ON fs.categoryid = cat.categoryid
JOIN 
    "DimCountry" dc ON fs.countryid = dc.countryid
GROUP BY 
    ROLLUP (cat.category, dc.country)
ORDER BY 
    cat.category, total_sales DESC;