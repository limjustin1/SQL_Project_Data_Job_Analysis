/* Question: What skills are requireed for the top paying data analyst jobs?
- Add specific skills required for the role
- Why? Provides detailed look at which high paying jobs demand certain skills, 
helping job seekers understand which skills to develop
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name as company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id=company_dim.company_id
    WHERE
        job_title_short='Data Analyst' 
        AND 
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*, 
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
ORDER BY
    salary_year_avg DESC


