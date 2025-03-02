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

