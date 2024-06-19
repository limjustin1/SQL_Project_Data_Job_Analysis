/* 
Question: What are the most in demand skills for data analysts?
- Identify top 5 in demand skills for data analyst
- Focus on all job postings
- Why? Provide insight into the most valuable skills to learn
*/

SELECT 
   skills,
   count(skills_job_dim.job_id) as demand_skill
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
WHERE
    job_title_short='Data Analyst'
GROUP BY 
    skills
ORDER BY 
    demand_skill DESC
LIMIT 5

