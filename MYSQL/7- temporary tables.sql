-------------------- temporary tables --------------------
-- tables like normal tables to store data but within same session, after closing the server the table and it's data are gone
-- tables dont store a memory storage and not added to main data, just for using in same session and gone 
-- used for storing intermediate results during complex queries or data transformations.
-- If a temporary table has the same name as a regular table, the temporary table takes precedence within the session.
-- Add indexes to temporary tables to speed up queries, especially if you’re working with large datasets.
-- 1
create temporary table temp_table 
(
f_name varchar(50),
l_name varchar(50),
height numeric(10, 2) -- numeric/decimel for fractions like height, weight, salary -- slower + lager size
-- age int -- int for correct numbers like ID, age -- faster + samller size
);

insert into temp_table values('Mohamed', 'Nasr', 173.12), ('Fatma', 'Yousry', 169.9);

select * from temp_table;
drop temporary table temp_table;

-- 2
create temporary table salary as
select employee_id, first_name, last_name, salary
from employee_salary where salary >= 50000;

select * from salary;
drop temporary table salary;
