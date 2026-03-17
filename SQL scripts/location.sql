select * from location;
describe location;

-- CHANGING DATA TYPES
alter table location modify column Location_ID varchar(20);
alter table location modify column Nationality varchar(20);

-- REPLACE VALUES IN NATIONALITY
select distinct nationality from location;

set @@autocommit =0;
update location
set nationality = case nationality
when "us" then "American"
when "USA" then "American"
when "ame" then "American"
end
where nationality in ("us","usa","ame");
commit;
set @@autocommit =1;

select * from location where location_id >1;
-------

-- REPLCING NULL VALUES
select * from location where nationality = ' ';
select * from location where nationality is null;

set @@autocommit =0;
update location
set nationality = "Not Available"
where location_id = "LU9831";

select * from location where location_id = "LU9831";
commit;
set @@autocommit =1;

-- REMOVE DUPLICATES
select location_id,count(location_id) from location group by location_id having count(location_id)>1;

select distinct count(location_id) as uniq, location_id from location group by location_id having uniq>1;

select count(location_id) from location;

with cte as(
select temp_id,row_number() over (
partition by Location_ID order by temp_id) as uniq
from location)

delete from location where temp_id in (select temp_id from cte where uniq>1);

alter table location add column temp_id int auto_increment primary key;
select * from location;

