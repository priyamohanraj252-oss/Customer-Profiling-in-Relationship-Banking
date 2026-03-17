select* from loan;

create table raw_loan
like loan;
insert into raw_loan
select * from loan;
select* from raw_loan;

select* from loan;

-- REMOVING DUPLICATES
select * from loan
where client_id >1;

-- CHANGING DATA TYPES
alter table loan modify column Client_ID varchar(20);
alter table loan change column `Total_Credit_ Cards` Total_Credit_Cards int;
alter table loan modify column Credit_Card_Balance bigint;
alter table loan modify column Bank_Loans bigint;
alter table loan modify column Business_Lending bigint;
describe loan;

-- RENAMING COLUMN
alter table loan rename column credit_card_balance to Credit_Card_Outstanding;

-- ADD COLUMN TOTAL_LIABILITIES
alter table loan add column Total_Liabilities bigint;
select* from loan;

update loan 
set total_liabilities = credit_card_outstanding +bank_loans+ business_lending;
set sql_safe_updates=0;

-- REPLACE NULL VALUES
select * from loan
where credit_card_outstanding =0;

select * from loan
where credit_card_outstanding is null;

select avg(credit_card_outstanding) from loan;
select credit_card_outstanding from loan order by credit_card_outstanding asc;

update loan
set credit_card_outstanding = 3165
where credit_card_outstanding =0 ;
-----
select * from loan;
select bank_loans from loan where bank_loans is null;
select bank_loans from loan where bank_loans =0;

select avg(bank_loans) from loan;
select bank_loans from loan order by bank_loans asc;

select @@autocommit;
set autocommit =0;
update loan
set bank_loans = 16503
where bank_loans = 0;
set sql_safe_updates=0;
select * from loan;
commit;
set @@autocommit =1;
-------
select business_lending from loan where business_lending is null;
select business_lending from loan where business_lending = 0;

select avg(business_lending) from loan;

set @@autocommit=0;
update loan
set business_lending = 865716
where business_lending =0;
commit;
set @@autocommit =1;
-----
select * from loan;
select total_liabilities from loan where total_liabilities is null;
select total_liabilities from loan where total_liabilities=0;

-- REMOVING DUPLICATES
select client_id, count(client_id) from loan group by client_id having count(client_id)>1;

select distinct count(client_id) as total_unique , client_id from loan group by client_id having total_unique >1;
select * from loan;
select count(client_id) from loan;

-- CREATE TEMP PRIMARY ID SINCE DONT HAVE ONE TO DELETE DUPLICATES
alter table loan add column temp_id int auto_increment primary key;

with cte as(
select temp_id, row_number() over(
partition by client_id order by temp_id) as rn from loan)

delete from loan where temp_id in(select temp_id from cte where rn>1);