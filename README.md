# HiveLearnings
This repository consists of various queries used for querying data stored in HDFS and other distributed file systems.

# HIVE
To query and manipulate the data, Hive provides a SQL-like language called HiveQL.
This language has a so-called transpiler that translates the HiveQL into MapReduce jobs.
By default, Hive uses a built-in Derby SQL server. However, for production quality, it is common to use other databases such as MySQL or PostgresSQL.
All Hive installations require a metastore service that Hive uses to store table schemas and other metadata.

**Hive web interface (HWI)**- It is a simple graphical user interface (GUI) of the Hive. It is an alternative to using the Hive command line interface.

In addition to the built-in functions Hive provides, there are three types of function APIs: UDF, UDTF, and UDAF which all do very different things.
**Normal User Defined Functions (UDF)** Normal functions take inputs from a single row, and output a single value. Examples of built-in functions include unix_timestamp, round, and cos.
**User Defined Aggregation Function (UDAF)** Aggregate functions can operate over an entire table at once to perform some sort of aggregation. Examples of built-in aggregate functions include sum, count, min, and histogram_numeric.
**User Defined Table Function (UDTF)** Table functions are similar to UDF functions, but they can output both multiple columns and multiple rows of data. Examples of built-in table functions include explode, json_tuple, and inline.

**Data Partitioning-**
Data partitioning is a very powerful optimization technique. Data partitioning divides the data physically into sub directories and files based on a column value, such that, if we need to query data for a particular value, Hive will skip scanning any other data file with a different value. This helps us to skip a huge volume of data scan and we only work on subset of data that we care about. This helps in making the query very fast. Here we are creating our table partitioned by date so if we want data of a particular date we don’t have to refresh all the data.

**Static Partitioning-**
By default, the partition is static in HIVE.
(Strict Mode) requires an individual insert for each partition column. 


**Dynamic Partitioning-**
(Non-Strict Mode) allows for a single insert to partition the entire table. 
You do not mention Hard coded value to be inserted into partition column in your query.


**External Tables-**
Added advantage of external tables is that if we drop the table it will not delete the data from S3. Another advantage of external table is that multiple cluster and Big data engines (like Presto, Spark, Athena) can all work on data in parallel.

**Bucketing-**
Much like partitioning, bucketing is a technique that allows you to cluster or segment large sets of data to optimize query performance. Even after partitioning the data, what if still the data is huge? Then we can use buckets to give the best optimization.
Hashing algorithm is used internally to decide which data will go to which bucket.
It works well when used along with partitioning i.e. we create partitions and inside that data is stored in buckets.
Buckets can also be used alone. Bucketing can sometimes be more efficient when used alone. For example- Instead of creating 100 partitions(**directories**), we can create 100 buckets(**files**).
Whatever number of buckets you provide, those will be the number of reducers.Example- 4 buckets then 4 reduce tasks are created.

