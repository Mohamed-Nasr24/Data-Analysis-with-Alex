select * 
from layoffs_staging
order by 1;

-- getting number of total employees in company in every laid_off
alter table layoffs_staging
add column num_of_emp int;

update layoffs_staging
set percentage_laid_off = null
where percentage_laid_off = 0;

update layoffs_staging
set num_of_emp = total_laid_off * 100.0 / percentage_laid_off
where percentage_laid_off is not null;

select company, `date`, num_of_emp, total_laid_off
from layoffs_staging
order by 3 desc;

-- Exploring Data
-- max companies laid off
select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc
limit 10;

-- time domain
select min(`date`), max(`date`)
from layoffs_staging;

-- max indusries laid off
select industry, sum(total_laid_off)
from layoffs_staging
group by industry
order by 2 desc
limit 10;

-- max countries laid off
select country, sum(total_laid_off)
from layoffs_staging
group by country
order by 2 desc
limit 10;

-- max companies pay for employees
select 
	company, 
	sum(funds_raised_millions), 
    sum(total_laid_off), 
    sum(funds_raised_millions) / sum(total_laid_off) as raised_per_person
from layoffs_staging
group by company
order by 4 desc
limit 10;

-- max laid off in same year
select year(`date`), sum(total_laid_off)
from layoffs_staging
group by year(`date`)
order by 1 desc;

select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging
where substring(`date`, 1, 7) is not null
group by `month`
order by `month`;

with rolling_total as (
	select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging
where substring(`date`, 1, 7) is not null
group by `month`
order by `month`
)
select `month`, total_off, sum(total_off) over(order by `month`) as rolling_sum
from rolling_total;

with company_year (company, years, total_off) as (
	select company, year(`date`), sum(total_laid_off)
    from layoffs_staging
    where year(`date`) is not null
    group by company, year(`date`)
    order by 3 desc
), 
company_year_rank as( 
	select *,
		dense_rank() over(partition by years order by total_off desc) as rn
	from company_year
)
select * 
from company_year_rank
where rn <= 5;
