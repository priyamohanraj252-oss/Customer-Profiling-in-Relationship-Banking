CREATE DATABASE CUSTOMER_PROFILING;
use customer_profiling;
select * from customer_behavior;
describe customer_behavior;

-- CHANGING DATA TYPES
alter table customer_behavior modify column Client_ID varchar (20);
alter table customer_behavior modify column Customer_ID int;
alter table customer_behavior modify column Location_ID varchar(20);
alter table customer_behavior modify column Estimatedincome bigint;
alter table customer_behavior modify column Superannuation_Savings bigint;
alter table customer_behavior modify column Bank_Deposits bigint;
alter table customer_behavior modify column Checking_Accounts bigint;
alter table customer_behavior modify column Saving_Accounts bigint;
alter table customer_behavior modify column Foreign_Currency_Account bigint;

-- RENAMING COLUMN
alter table customer_behavior
rename column Estimated_Income to EstimatedIncome;

alter table customer_behavior change `custome_ id` customer_id int;
alter table customer_behavior rename column customer_id to Customer_ID;

-- CHANGING CLIENT_ID INTO UPPERCASE
update customer_behavior
set client_id=upper(client_id)
where client_id in ("pkR81288","pkR65833","pkR47499");
set sql_safe_updates =0;

-- REPLACING NULL VALUES
select client_id,Estimatedincome from customer_behavior
where estimatedincome is null;

update customer_behavior
set bank_deposits = case bank_deposits
when bank_deposits= 0 then 100101.9762
end 
where bank_deposits in (0);

update customer_behavior 
set bank_deposits = 100101.9762
where bank_deposits is null;

select bank_deposits  from customer_behavior
order by bank_deposits asc;

select client_id,checking_accounts from customer_behavior where checking_accounts is null;
select min(checking_accounts) as min_bal from customer_behavior;
select checking_accounts from customer_behavior order by checking_accounts asc;

update customer_behavior
set checking_accounts = 5513.335
where checking_accounts is null ;

update customer_behavior
set checking_accounts = case checking_accounts
when checking_accounts =0 then 5513.335
end
where checking_accounts in (0);

select min(saving_accounts) from customer_behavior;
select saving_accounts,client_id from customer_behavior order by saving_accounts asc; 


update customer_behavior
set saving_accounts = case 
when saving_accounts =0 then 3719.759183
when saving_accounts is null then 3719.759183
else saving_accounts
end;

select foreign_currency_account, client_id from customer_behavior order by foreign_currency_account asc;
select foreign_currency_account from customer_behavior where foreign_currency_account is null or "0";
select * from customer_behavior;

select foreign_currency_account from customer_behavior where foreign_currency_account is null or "0";

-- REMOVING DUPLICATES
select distinct client_id from customer_behavior;

select client_id,count(client_id) from customer_behavior
group by client_id
having count(client_id) >1;

select distinct count(client_id) as uniq_id, client_id from customer_behavior group by client_id having uniq_id>1;
select * from customer_behavior;

-- TO REMOVE DUPLICATES ONLY WE NEED ANOTHER PRIMARY KEY TO PASS CONDITION WITH 
select count(customer_id) from customer_behavior;

with cte as(
select customer_id, row_number() over(
partition by client_id order by customer_id) as rn from customer_behavior)

delete from customer_behavior where customer_id in (select customer_id from cte where rn>1);
set sql_safe_updates=0;

-- ADD COLUMN TOTAL_LIQUID_ASSET
alter table customer_behavior add column Total_Liquid_asset bigint;
update customer_behavior
set total_liquid_asset = checking_accounts + saving_accounts;
set sql_safe_updates =0;
select * from customer_behavior;

-- ADD COLUMN ASSET_UNDER_MANAGEMENT
alter table customer_behavior add column Asset_Under_Management bigint;
update customer_behavior
set asset_under_management = superannuation_savings+bank_deposits+ checking_accounts+saving_accounts+foreign_currency_account;





