/* Question: What are the top paying skills based on salary?
- Look at the average salary associated with each skill
- Focus on role with specified salaries
- Why? Reveals how different skills impact salary levels 
and helps identify most rewarding skills to acquire
*/


SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
