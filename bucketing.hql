--Bucket Example
set hive.enforce.bucketing = true;
set hive.exec.dynamic.partition.mode = nonstrict;

--create table with partition and buckets
create table if not exists dept_buck(deptno int, empname string, sal int, location string)
partitioned by(deptname string)
clustered by (location) into 4 buckets
row format delimited fields terminated by ','
lines terminated by '\n'
stored as textfile;

--dynamic partition is used below
insert into table dept_buck partition(deptname)
select col1, col3, col4, col5, col2 from dept_with_loc;
