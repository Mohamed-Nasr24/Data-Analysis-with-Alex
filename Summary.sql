select *
from parks_and_recreation.employee_demographics;

select Distinct gender 
from parks_and_recreation.employee_demographics;

select distinct gender, first_name
from parks_and_recreation.employee_demographics;

select first_name, (age + 10) as new_age
from parks_and_recreation.employee_demographics
where age > 35;

select first_name
from parks_and_recreation.employee_demographics
where birth_date > '1985-01-01';

-- like 
-- _ ==> just one chaar 
-- % ==> any number of chars 
select *
from parks_and_recreation.employee_demographics
where first_name like 'a__' or first_name like 'd%';

-- group by 
select gender, avg(age) as avg_age, count(*) as counter
from parks_and_recreation.employee_demographics
group by gender;

-- order by 
-- default asc 
select *
from parks_and_recreation.employee_demographics
order by gender desc, first_name asc;

-- group by
-- having
-- in case of using group by and want to filter with num, we use having.
select occupation, avg(salary) as avg_salary
from parks_and_recreation.employee_salary
where occupation like '%Manager%'
group by occupation having avg_salary > 60000;

-- limit
-- selecting top determined number of records
-- limit num1, num2 ==> num1 the number of skipped records, num2 the number of chose records to select and print   
select *
from parks_and_recreation.employee_salary
where occupation like '%Manager%'
order by salary desc
limit 1,2; -- skip first record and select the 2 records after first skipped one

-- joins -- it merge data horizontally 
select sal.employee_id, sal.first_name, sal.last_name, salary
from parks_and_recreation.employee_salary sal
join parks_and_recreation.employee_demographics demo
	on sal.employee_id = demo.employee_id;

-- union ==> used to compine rows with no duplicates -- it merge data vertically 
-- union all ==> to compine all records and duplicates
select first_name, last_name, 'old man' as label
from parks_and_recreation.employee_demographics
where age > 40 and gender = 'male'
union 
select first_name, last_name, 'old lady'
from parks_and_recreation.employee_demographics
where age > 40 and gender = 'female'
union 
select first_name, last_name, 'high paid'
from parks_and_recreation.employee_salary
where salary > 70000
order by first_name, last_name;

-------------------- string functions --------------------
select length('MR Heinz ist meine seele');
select first_name, length(first_name) as name_length
from parks_and_recreation.employee_salary
order by 2;

select lower(first_name), upper(last_name)
from parks_and_recreation.employee_demographics; 

select trim('             nasr                 ')
union
select ltrim('             nasr                 ')
union
select rtrim('             nasr                 ');

select 
	first_name, 
    left(first_name, 4) as first_4_chars,
    right(first_name, 4) as last_4_chars,
    substring(birth_date, 6, 2) as birth_month -- substring(col, start, length)
from parks_and_recreation.employee_demographics;

select first_name, replace(first_name, 'a', 'o')
from parks_and_recreation.employee_demographics;

select first_name, locate('A', first_name) -- to determine index of specific val
from parks_and_recreation.employee_demographics;

select 
	first_name, 
    last_name, 
    concat(first_name, ' ', last_name) as full_name 
from parks_and_recreation.employee_demographics;

-------------------- Case statement --------------------
select
	concat(first_name, ' ', last_name) as full_name,
    age,
case 
	when age < 30 then 'Young'
    when age between 30 and 50 then 'intermediate'
    else 'old'
end as age_status
from parks_and_recreation.employee_demographics
order by age;


select demo.employee_id,
	concat(sal.first_name, ' ', sal.last_name) as full_name,
    sal.salary,
    sal.dept_id,
case 
	when salary <= 50000 then 1.05 * sal.salary
    when salary > 50000 then 1.07 * sal.salary
    when dept_id = 6 then 1.1 * sal.salary
end as new_salary
from parks_and_recreation.employee_salary sal
join parks_and_recreation.employee_demographics demo
	on sal.employee_id = demo.employee_id
order by new_salary;

-------------------- subqueries --------------------
-- subquery just return 1 col
select *
from parks_and_recreation.employee_demographics 
where employee_id in 
					(select employee_id 
					from parks_and_recreation.employee_salary 
                    where dept_id = 1);
select 
	first_name, 
    salary,
    (select avg(salary) from parks_and_recreation.employee_salary)
from parks_and_recreation.employee_salary;

select avg(`avg(age)`), avg(max_age)
from (
	select gender, avg(age), max(age) as max_age, min(age), count(gender)
    from parks_and_recreation.employee_demographics
    group by gender
    ) as agg_age;				
    
-------------------- window_fucntion --------------------
-- 1
select gender, round(avg(salary), 2) as avg_salary
from parks_and_recreation.employee_demographics demo
join parks_and_recreation.employee_salary sal
	on demo.employee_id = sal.employee_id
group by gender;

-- 2
select demo.first_name, demo.last_name, gender, round(avg(salary) over(partition by gender), 2) as avg_salary
from parks_and_recreation.employee_demographics demo
join parks_and_recreation.employee_salary sal
	on demo.employee_id = sal.employee_id;

-- 3
select demo.first_name, demo.last_name, gender, sal.salary, round(sum(salary) over(partition by gender order by demo.age), 2) as roll_total
from parks_and_recreation.employee_demographics demo
join parks_and_recreation.employee_salary sal
	on demo.employee_id = sal.employee_id;

-- 4
select 
	row_number() over(partition by gender order by salary desc) as row_num,
	rank() over(partition by gender order by salary desc) as rank_num, -- skip numbers in dublication 
	dense_rank() over(partition by gender order by salary desc) as dense_rank_num, -- not skipping nums in dublication
	demo.first_name, 
    demo.last_name, 
    gender, 
    sal.salary
	-- sum(salary) over(partition by gender order by salary) as roll_tot
from parks_and_recreation.employee_demographics demo
join parks_and_recreation.employee_salary sal
	on demo.employee_id = sal.employee_id;
    
    
-------------------- CTE --------------------
-- must be used in same query not after the query 
with cte_1 (ID, Gender) as(
select employee_id, gender
from parks_and_recreation.employee_demographics 
),
cte_2 (ID, First_Name, Last_Name, Salary) as (
select employee_id, first_name, last_name, salary
from parks_and_recreation.employee_salary
)
select * -- First_Name, Last_Name, Gender, Salary
from cte_1 ct1
join cte_2 ct2
	on ct1.ID = ct2.ID
order by Salary;

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
-------------------- i --------------------

