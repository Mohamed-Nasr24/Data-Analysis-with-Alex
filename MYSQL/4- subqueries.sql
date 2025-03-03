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
