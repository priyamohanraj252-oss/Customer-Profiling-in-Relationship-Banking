SELECT * FROM customer_profiling.relationship_banking;
describe relationship_banking;

-- CHANGING DATA TYPES
alter table relationship_banking modify column Banking_contact varchar(50);
alter table relationship_banking modify column Investment_Advisor varchar (20);
alter table relationship_banking modify column Fee_Structure varchar(20);
alter table relationship_banking modify column Loyalty_Classification varchar(20);
alter table relationship_banking modify column Banking_Relationship varchar(20);
alter table relationship_banking modify column Risk_Weighting tinyint;

alter table relationship_banking rename column bankin_relationship to Banking_Relationship;

-- ADD DATE COLUMN TO CHANGE INTO DATE FORMAT
select count(joined_bank_on) from relationship_banking where joined_bank_on is null;
select * from relationship_banking;

alter table relationship_banking add column Joined_Bank_On date;
update relationship_banking 
set joined_bank_on = str_to_date(joined_bank_on, '%d.%m.%Y');
set sql_safe_updates=0;

select @@autocommit;
set @@autocommit=1;
commit;

/*
set @@cte_max_recursion_depth=3000;

with recursive dates as (
select str_to_date('23.05.1992','%d.%m.%Y') as dt , 1 as n
union all
select dt+interval 1 day,n+1
from dates where n<3000)
update relationship_banking rb
join (select dt,n from dates) d
on rb.relationship_id=d.n
set rb.Joined_Bank_on = d.dt
where rb.joined_bank_on is null;
set sql_safe_updates=0; */

UPDATE relationship_banking
SET Joined_Bank_On =
DATE_ADD('1992-05-23', INTERVAL Relationship_ID - 1 DAY)
WHERE Joined_Bank_On IS NULL;

select * from relationship_banking;

-- REMOVING NULL VALUES
select * from relationship_banking where Relationship_ID is null;
select count(joined_bank_on) from relationship_banking;

set @@autocommit =0;
delete from relationship_banking where Relationship_ID is null;
commit;
set @@autocommit =1;
select * from relationship_banking;

alter table relationship_banking drop column joined_bank;
-------
select * from relationship_banking where Relationship_ID =0 or Relationship_ID is null;
select * from relationship_banking where Banking_contact = ' ';
select * from relationship_banking where Banking_contact is null;
select * from relationship_banking where Investment_Advisor = ' ' or Investment_Advisor is null;
select * from relationship_banking where Fee_Structure = ' ' or Fee_Structure is null;

set @@autocommit=0;
update relationship_banking
set fee_structure = "Not Available" where fee_structure is null;
commit;
set @@autocommit=1;

select * from relationship_banking where Loyalty_Classification = ' ' or Loyalty_Classification is null; 
update relationship_banking
set loyalty_classification = "Not Available"
where loyalty_classification is null;
commit;
set @@autocommit=1;

select * from relationship_banking where banking_relationship = ' ' or banking_relationship is null;
update relationship_banking
set banking_relationship = "Not Available"
where banking_relationship is null;

select * from relationship_banking where Risk_Weighting = ' ' or Risk_Weighting is null or Risk_Weighting =0;
select avg(Risk_Weighting) from relationship_banking;
update relationship_banking
set Risk_Weighting = 2 
where Risk_Weighting is null;

select * from relationship_banking where Joined_Bank_On is null;

-- REMOVING DUPLICATES
select distinct count(relationship_id),Relationship_ID from relationship_banking 
group by relationship_id having count(relationship_id) >1
order by relationship_id;

select count(relationship_id) from relationship_banking;
select * from relationship_banking;

alter table relationship_banking add column tempid int auto_increment primary key;

with cte as(
select tempid, row_number() over( 
partition by relationship_id order by tempid) as rn from relationship_banking)

delete from relationship_banking where tempid in (select tempid from cte where rn>1);
select @@autocommit;

-- Change lower case to proper case
select * from relationship_banking;
set @@autocommit=0;
update relationship_banking
set banking_contact= concat (
upper(left(substring_index(banking_contact,' ',1),1)),
lower(substring(substring_index(banking_contact,' ',1),2)),' ',
upper(left(substring_index(banking_contact,' ',-1),1)),
lower(substring(substring_index(banking_contact,' ',-1),2))
)
where banking_contact is not null;
rollback;
commit;
set @@autocommit=1;

/*UPDATE relationship_banking
SET banking_contact = CONCAT(
    UPPER(LEFT(SUBSTRING_INDEX(banking_contact,' ',1),1)),        -- First letter first word
    LOWER(SUBSTRING(SUBSTRING_INDEX(banking_contact,' ',1),2)),   -- Rest of first word
    ' ',
    UPPER(LEFT(SUBSTRING_INDEX(banking_contact,' ',-1),1)),       -- First letter last word
    LOWER(SUBSTRING(SUBSTRING_INDEX(banking_contact,' ',-1),2))   -- Rest of last word
)
WHERE banking_contact IS NOT NULL;*/

set @@autocommit =0;
select * from relationship_banking;

update relationship_banking
set investment_advisor= concat(
upper(left(substring_index(investment_advisor,' ',1),1)),
lower(substring(substring_index(investment_advisor,' ',1),2)), 
' ',
upper(left(substring_index(investment_advisor,' ',-1),1)),
lower(substring(substring_index(investment_advisor,' ',-1),2))
)
where investment_advisor is not null;
commit;
set @@autocommit=1;