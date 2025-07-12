# 🗄️ **2. Setup NoSQL Database Using MongoDB**

This phase involves setting up the **NoSQL database** to store e-commerce catalog data, performing queries, and exporting data.



## 🎯 **Objectives**

✅ Store catalog data for the e-commerce platform

✅ Load data into MongoDB

✅ Query and export catalog data



## 📥 **Import Data into MongoDB**

### **Prerequisites**

Ensure `mongoimport` and `mongoexport` are installed.

### **Steps**

1. **Download the catalog data:**
   [`catalog.json`](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/nosql/catalog.json)

2. **Import `catalog.json` into MongoDB:**

```bash
mongoimport \
  -u root \
  -p YOUR_MONGODB_PASSWORD \
  --authenticationDatabase admin \
  --db catalog \
  --collection electronics \
  --file catalog.json \
  --host mongo
```

✅ Expected output:

```
438 document(s) imported successfully.
```



## 🗂️ **Verify Data Import**

### **List all databases:**

```mongodb
show dbs;
```

✅ Example output:

```
admin     100.00 KiB
catalog    48.00 KiB
config     12.00 KiB
local      72.00 KiB
```

### **List collections in the `catalog` database:**

```mongodb
use catalog
show collections;
```

✅ Output:

```
electronics
```

### **Check number of documents in `electronics` collection:**

```mongodb
catalog> db.electronics.find().count();
```

✅ Output:

```
438
```

### **View first 5 documents:**

```mongodb
catalog> db.electronics.find().limit(5);
```

✅ Sample output:

```json
[
  { "_id": ObjectId("..."), "type": "smart phone", "model": "c3", "screen size": 6 },
  { "_id": ObjectId("..."), "type": "smart phone", "model": "bn20", "screen size": 6 },
  ...
]
```



## ⚙️ **Create Index**

To optimize queries, create an index on the `type` field:

```mongodb
catalog> db.electronics.createIndex({ type: 1 });
```

✅ Output:

```
type_1
```

### **Verify indexes:**

```mongodb
catalog> db.electronics.getIndexes();
```

✅ Output:

```json
[
  { "v": 2, "key": { "_id": 1 }, "name": "_id_" },
  { "v": 2, "key": { "type": 1 }, "name": "type_1" }
]
```



## 🔎 **Query Data**

### **Find count of laptops:**

```mongodb
catalog> db.electronics.countDocuments({ type: "laptop" });
```

✅ Output:

```
389
```



### **Find count of smart phones with 6-inch screens:**

```mongodb
catalog> db.electronics.countDocuments({ type: "smart phone", "screen size": 6 });
```

✅ Output:

```
0
```



### **Calculate average screen size of smart phones:**

```mongodb
catalog> db.electronics.aggregate([
  { $match: { type: "smart phone" } },
  { $group: { _id: null, avgScreenSize: { $avg: "$screen size" } } }
]);
```

✅ Output:

```json
[ { "_id": null, "avgScreenSize": 6 } ]
```



## 💾 **Export Data from MongoDB**

Export specific fields (`_id`, `type`, `model`) to a CSV file:

```bash
mongoexport \
  -u root \
  -p YOUR_MONGODB_PASSWORD \
  --authenticationDatabase admin \
  --db catalog \
  --collection electronics \
  --out electronics.csv \
  --type=csv \
  --fields _id,type,model \
  --host mongo
```

✅ Output:

```
exported 438 records
```

🔗 **Exported data:** [`electronics.csv`](../02_nosql/data/electronics.csv)

✅ Sample rows:

```
_id,type,model
ObjectId(...),smart phone,bn20
ObjectId(...),smart phone,xm23
...
```



## 🗂️ **Project Phases**

🔗 **Next Steps:**

1. [Setup OLTP database using MySQL](../01_oltp/01_oltp.md)
2. ✅ Setup NoSQL database using MongoDB
3. [Build Data Warehouse using PostgreSQL](../03_dwh/03_dwh.md)
4. [Create Business Intelligence Dashboard using Tableau](../04_analytics/04_analytics.md)
5. [Create ETL Data Pipelines using Apache Airflow](../05_etl/05_etl.md)
6. [Perform Big Data Analytics with Apache Spark](../06_spark/06_spark.md)

