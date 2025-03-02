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