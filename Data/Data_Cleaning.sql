-------------------- cleaning Data --------------------
/*
1- remove dublicates 
2- Standarize data
3- Null/Blank values 
4- Remove nulls/blanks and any unnacessarry columns
*/
select *
from layoffs;

-- creating new table to deal with and keeping the origin 
create table layoffs_staging
like layoffs;

select *
from layoffs_staging;

-- check dublicates 
with dublicates_cte as (
		select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
		from layoffs_staging
)
select * from dublicates_cte
where row_num > 1;

-- adding new column row_num
alter table layoffs_staging
add column row_num int;

-- inserting all data with row_num counter 
insert into layoffs_staging
select *, row_number() over(
	partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
		as row_num
from layoffs;

-- deleting dublicates 
delete
from layoffs_staging
where row_num > 1;

----------- Standrizing Data -----------
-- handling soaces in company name
update layoffs_staging
set company = trim(company);

-- removing dots from country name
update layoffs_staging
set country = trim(trailing '.' from country);
 
select country, count(country) as cnt
from layoffs_staging
group by country
order by 2;
 
-- updating names 
select distinct industry 
from layoffs_staging
order by 1;

update layoffs_staging -- there are many names having 'Crypto' word
set industry = 'Crypto'
where industry like 'Crypto%';

select industry
from layoffs_staging
where industry like 'Fin%'; -- there are (Finance, Fin-Tech)

update layoffs_staging
set industry = 'Finance'
where industry like 'Fin%';

-- converting text to date in table 
update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y');

-- to convert data type in schema 
alter table layoffs_staging
modify column `date` Date;


----------- Deleting NULLs -----------
select *
from layoffs_staging
where 
	total_laid_off is null 
    and percentage_laid_off is null
    and funds_raised_millions is null;

select t1.industry, t2.industry
from layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
	and (t2.industry is not null or t2.industry != '');
 
 -- to change all '' to nulls 
update layoffs_staging
set industry = null
where industry = '';

update layoffs_staging t1
join layoffs_staging t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
	and t2.industry is not null;

select *
from layoffs_staging
where industry is null;

-- delete empty rows with no effect
delete from layoffs_staging
where 
	total_laid_off is null 
    and percentage_laid_off is null
    and funds_raised_millions is null;

-- delete unnacessarry cols 
alter table layoffs_staging
drop column row_num;

select * 
from layoffs_staging;