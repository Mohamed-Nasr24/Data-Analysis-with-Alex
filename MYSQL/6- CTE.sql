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
