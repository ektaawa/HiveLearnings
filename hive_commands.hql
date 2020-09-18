--Static Partitioning:
INSERT INTO TABLE employees_partitioned PARTITION(department='A') SELECT EmployeeID, FirstName, JobTitle, Salary FROM employees_staging WHERE department='A'; 
INSERT INTO TABLE employees_partitioned PARTITION (department='B') SELECT EmployeeID, FirstName, JobTitle, Salary FROM employees_staging WHERE department='B';

--Changing it to Dynamic Partitioning:
SET hive.exec.dynamic.partition = true; 
SET hive.exec.dynamic.partition.mode = nonstrict; 
INSERT OVERWRITE TABLE ontime_partitioned PARTITION(Year, Month) SELECT DayofMonth, DayOfWeek, DepTime, CRSDepTime, ArrTime, CRSArrTime, UniqueCarrier, 
FlightNum, TailNum, ActualElapsedTime, CRSElapsedTime, AirTime, ArrDelay, DepDelay, Origin, Dest, Distance, TaxiIn, TaxiOut, Cancelled, CancellationCode, 
Diverted, CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay, Year, Month FROM ontime_2007_staging;

--To see the details of Partition:
show partitions employees_partitioned; 
describe extended employees_partitioned;
describe formatted ontime_partitioned partition(year=2007, month=2);

--Suppose we have just received data for the month of January in 1976 and we need to add a new partition:
alter table ontime_partitioned add if not exists partition (year=1976, month=1) location 'hdfs://horton/user/hive/warehouse/ontime_partitioned/year=1976/month=1'; 
load data inpath '/tmp/1976.csv' into table ontime_partitioned partition (year=1976, month=1); 
select * from ontime_partitioned where year = 1976;

--Changing partition location:
alter table ontime_partitioned partition(year=1976, month=1) 
set location 'hdfs://sandbox.hortonworks.com:8020/apps/hive/warehouse/somewhere_else';

--To drop a partition, use the following command:
alter table ontime_partitioned 
drop if exists partition(year=1976, month=1);

--creating HDFS directories for foodmart tables:
hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/inventory_fact_1998
hdfs dfs -mkdir /apps/hive/warehouse/soccer.db
hdfs dfs -mkdir /apps/hive/warehouse/soccer.db/soccer_details
hdfs dfs -mkdir /apps/hive/warehouse/soccer_data

--copying sample data files to HDFS corresponding directories:
hdfs dfs -copyFromLocal /home/hive/foodmart_data/inventory_fact_1998 /apps/hive/warehouse/foodmart.db/inventory_fact_1998/
hdfs dfs -copyFromLocal /home/hive/soccer_dataset.csv /apps/hive/warehouse/soccer.db/soccer_details

--To give read, write, exec permission
hdfs dfs -chmod -R 777 /apps/hive/warehouse/foodmart.db
hdfs dfs -chmod -R 777 /apps/hive/warehouse/soccer.db 

--To know the details of the table:
describe soccer_details;

--To print table with column names- set the property:
set hive.cli.print.header = true;

--Skip Header and Footer:
create external table testtable (name string, message string) 
row format delimited fields terminated by '\t' 
lines terminated by '\n' 
location '/testtable' 
tblproperties ("skip.header.line.count"="1", "skip.footer.line.count"="2");





