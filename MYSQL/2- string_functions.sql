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
