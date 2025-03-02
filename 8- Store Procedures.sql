-- it's a approach to save some fixed query that happens many times 
-- in MySQL is essential when creating stored procedures, functions, triggers, or events.
----- that's to avoid conflict between end of inner query and end of entire procedure or event 

-- 1
delimiter $$ -- to change delimiter from ; to $$
use parks_and_recreation$$
create procedure max_salaries ()
begin 
	SELECT *
	FROM employee_salary
	WHERE salary >= 70000;
end$$
delimiter ; -- to retune delimiter to ; again

-- 2 
delimiter $$
use parks_and_recreation$$
create procedure max_salaries_ages ()
begin 
	SELECT *
	FROM employee_salary
	WHERE SALARY >= 70000;
    select *
    from employee_demographics
    where age > 40;
end$$ -- max_salaries_agesmax_salaries
delimiter ;

-- 3
delimiter $$ 
use parks_and_recreation$$
create procedure salary_per_gender ()
begin 
	select round(avg(sal.salary), 2) as avg_salary, gender
    from employee_salary sal
    join employee_demographics demo
		on sal.employee_id = demo.employee_id
	group by gender;
end$$
delimiter ;

-- 4
-- passing a parameter to select particular data
delimiter $$
use parks_and_recreation$$
create procedure Birth_date (f_name varchar(50), l_name varchar(50))
begin
	select age, birth_date
    from employee_demographics
    where first_name = f_name and last_name = l_name;
end$$
delimiter ;

call max_salaries();
call max_salaries_ages();
call salary_per_gender();
call Birth_date('Donna', 'Meagle');