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
