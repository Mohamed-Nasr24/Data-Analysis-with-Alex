-- it's procedure that happens auto when doing particular action 
	-- without calling it 
/* -- basic syntax
	CREATE TRIGGER trigger_name
	{BEFORE | AFTER} {INSERT | UPDATE | DELETE}
	ON table_name
	FOR EACH ROW
	BEGIN
		-- Trigger logic here
	END;
    
OLD: Refers to the row before the event (used in UPDATE and DELETE).
NEW: Refers to the row after the event (used in INSERT and UPDATE).
*/

select * 
from employee_demographics;

select *
from employee_salary;

-- 1
delimiter $$
use parks_and_recreation$$
create trigger update_tables
	after insert on employee_salary
    for each row
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end$$
delimiter ;

insert into employee_salary 
values (24, 'Mohamed', 'Nasr', 'Data Analyst', 70000, 1);


-- 2 
delimiter $$
use parks_and_recreation$$
create trigger enforce_min_salary
	before insert on employee_salary
    for each row
begin 
	if new.salary < 30000
		then set new.salary = 30000;
    end if;
end$$
delimiter ;

insert into employee_salary values (13, 'Mo', 'Nasssr', 'Data Analyst', 29999, 1);
select * from employee_salary;
