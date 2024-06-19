select avg(salary_year_avg),
    avg(salary_hour_avg),
    job_schedule_type
from job_postings_fact
where job_posted_date>'2023-06-01'
GROUP BY job_schedule_type;

select count(job_id),
extract(month from job_posted_date at time zone 'EDT') as date_month
from job_postings_fact
GROUP BY date_month
order by date_month asc;

select *
from company_dim

select *
from job_postings_fact
limit 5

select company_dim.name,
job_postings_fact.job_health_insurance,
extract(month from job_posted_date)as date_month
from company_dim inner join job_postings_fact on company_dim.company_id=job_postings_fact.company_id
where job_health_insurance='TRUE' and extract(month from job_posted_date)>3
order by date_month;

CREATE TABLE january_jobs AS
select job_title_short, company_id, job_location, job_posted_date
from job_postings_fact
where extract(month from job_posted_date) = 1;

select*
from january_jobs

CREATE TABLE february_jobs AS
SELECT job_posted_date
FROM job_postings_fact
WHERE EXTRACT(month FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
SELECT job_posted_date
FROM job_postings_fact
WHERE EXTRACT(month FROM job_posted_date) = 3;


--categorize job locations
select 
job_title_short,
job_location,
    case
        when job_location ='Anywhere' then 'Remote'
        when job_location like '%TX%' then 'In-state'
        else 'Onsite'
    end as location_category
from job_postings_fact;


--# of jobs for each locattion category (bucketing)
select 
count(job_id) as number_of_jobs,
    case
        when job_location ='Anywhere' then 'Remote'
        when job_location like '%TX%' then 'In-state'
        else 'Onsite'
    end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_category
order by number_of_jobs;

--subqueries and CTE
select 
    company_id,
    name as company_name
from company_dim
where company_id in (

    select 
        company_id
    from 
        job_postings_fact
    where 
        job_no_degree_mention='true'

)

--Find the companies with the most job openings
with  company_job_count as (
   select company_id,
count(*) as total_jobs
from job_postings_fact
group by company_id
)
select company_dim.name as company_name,
company_job_count.total_jobs
from company_dim
left join company_job_count on company_job_count.company_id=company_dim.company_id
order by total_jobs desc


select skills
from skills_dim
where skill_id in (

    select skill_id,
count(*) as total_skill
from skills_job_dim
group by skill_id
order by total_skill desc
)


select skills, total_skill
from(
    select skill_id, count(*) as total_skill
    from skills_job_dim
    group by skill_id
    order by total_skill desc
    limit 5
) as sub
join skills_dim on sub.skill_id = skills_dim.skill_id


--categorize company jobs postings based on size
with job_postings as (
    select name, total_jobs
    from (
        select  company_id, count(*) as total_jobs
        from job_postings_fact
        group by company_id
    ) as sub_job_postings
join company_dim on sub_job_postings.company_id=company_dim.company_id
)

select total_jobs, name,
case
    when total_jobs < 10 then 'Small'
    when total_jobs >= 10 and total_jobs <=50 then 'Medium'
    when total_jobs > 50 then 'Large'
 end as size
 from job_postings


--find count of number of remote job postings for data analysts
with remote_job_skills as (
    select skill_id,  count(*) as skill_count
    from skills_job_dim
    inner join job_postings_fact on skills_job_dim.job_id=job_postings_fact.job_id
    where job_postings_fact.job_work_from_home = true
    and job_postings_fact.job_title_short = 'Data Analyst'
    group by skill_id
)

select skills_dim.skill_id, skill_count, skills
from remote_job_skills
inner join skills_dim on skills_dim.skill_id=remote_job_skills.skill_id
order by skill_count desc
limit 5


--UNIONS comebines results from 2+ select statements
select *
from january_jobs

UNION

select *
from february_jobs

UNION

select * 
from march_jobs








