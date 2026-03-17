use customer_profiling;

-- CREATING NEW TABLE
create table raw_customer_details
like customer_details;
insert into raw_customer_details
select * from customer_details;

select * from raw_customer_details;
describe customer_details;
select * from customer_details;

-- CHANGING DATA TYPES
alter table customer_details modify column Name varchar(30);
select name from customer_details where length(name) >20;

set sql_safe_updates =0;
alter table customer_details modify column Age int;
update customer_details
set age = replace(age, '%', '');
update customer_details
set age = age/100;

alter table customer_details modify column Sex varchar(20);
alter table customer_details modify column Occupation varchar(50);
alter table customer_details change `Properties Owned` Properties_Owned  int;

-- CHANGING NAME TO PROPER CASE
select * from customer_details;
select @@autocommit;
set @@autocommit = 1;
update customer_details
set name  = concat(
upper(left(substring_index(name,' ' ,1),1)),lower(substring(substring_index(name,' ' ,1),2)),' ',
upper(left(substring_index(name,' ',-1),1)),lower(substring(substring_index(name,' ',-1),2))
);
set sql_safe_updates=0;
commit;

