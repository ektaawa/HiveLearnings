--Create Database
create schema if not exists soccer;

--Use the database
use soccer;

--HIVE CONF
--Dynamic Partition
set hive.exec.dynamic.partition.mode = nonstrict;
set hive.exec.dynamic.partition = true;

--Create temporary table
create external table if not exists soccer.soccer_details
(Year STRING,City STRING,Sport STRING,Discipline STRING,Athlete STRING,Country STRING,Gender STRING,Event STRING,Medal STRING)
row format delimited
fields terminated by '\t'
stored as textfile
location 'hdfs://sandbox.hortonworks.com:8020/apps/hive/warehouse/soccer.db/soccer_details';

--Load data into temprary table
load data inpath 'hdfs://sandbox.hortonworks.com:8020/apps/hive/warehouse/soccer_data/soccer_dataset.csv' into table soccer.soccer_details;

--Create Partitioned table
create external table if not exists soccer.soccer_dp_details(
city string,sport string,discipline string,athlete string,country string,gender string,event string,medal string)
partitioned by (year string)
stored as textfile
location 'hdfs://sandbox.hortonworks.com:8020/apps/hive/warehouse/soccer_data';

--Load Data into partitioned table by using insert override
insert overwrite table soccer.soccer_dp_details partition (year)
select year,city,sport,discipline,athlete,country,gender,event,medal from soccer.soccer_details;

--To know the schema details of the table
desc formatted soccer.soccer_dp_details;

--To list all the partitions of a table
show partitions soccer.soccer_dp_details;

--To check the default location where data is stored:
set hive.metastore.warehouse.dir;
--output:
hive.metastore.warehouse.dir=/apps/hive/warehouse


