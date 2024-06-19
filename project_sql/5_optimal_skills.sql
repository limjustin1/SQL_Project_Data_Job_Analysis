/* What are the most optimal skills to learn (high demand and high paying)
- Identify skills in high demand and associated with high average salary for data analyst role
- concentrate on remote positions with specified salaries
- Why? Targets skills that offer job security and financial benefit, 
offer insight into career development
*/

WITH top_paying_skill as (
SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE 
    avg_salary IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY skills_job_dim.skill_id
),
top_demand_skill as (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
   count(skills_job_dim.job_id) as demand_skill
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst'
GROUP BY skills_dim.skill_id
)

SELECT 
    top_demand_skill.skill_id,
    top_demand_skill.skills,
    demand_skill,
    avg_salary
FROM top_demand_skill
LEFT JOIN top_paying_skill on top_demand_skill.skill_id=top_paying_skill.skill_id
WHERE demand_skill > 10
ORDER BY 
    demand_skill DESC,
    avg_salary DESC
LIMIT 25
