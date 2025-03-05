-- companies who give health insurance and have no mention of degree
SELECT 
    name as company_name
FROM
    company_dim
WHERE
    company_id In
    (SELECT 
        company_id
    FROM
        job_postings_fact
    WHERE   
        job_no_degree_mention = true
        AND
        job_health_insurance = true
    )
order by 1;


-- Companies that have the most job openings

WITH Company_job_count AS (
    SELECT 
        company_id,
        Count(*) as TotalJobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
    )

SELECT 
    company_dim.name,
    Company_job_count.TotalJobs
FROM
    company_dim
JOIN 
    Company_job_count
on
    company_dim.company_id = Company_job_count.company_id
ORDER BY
    2 DESC;


-- 5 most frequently mentioned skills for jobs

SELECT
    skills_dim.skills
FROM
    skills_dim
WHERE
    skills_dim.skill_id IN
(SELECT 
    skill_id
From
    skills_job_dim
GROUP BY
    skill_id
ORDER BY
    1 DESC
LIMIT 5);


-- Categorizing companies on basis of job posted by them

WITH Company_job_count AS
(
Select 
    Count(*) as numofJobs,
    company_id
From 
    job_postings_fact
GROUP BY
    company_id
)

SELECT 
    Company_job_count.company_id,
    company_dim.name as Company_name,
    numofJobs,
    CASE
            WHEN numofJobs <= 10 THEN 'Small'
            WHEN numofJobs BETWEEN 11 and 15 THEN 'Medium'
            ELSE 'Large'
        End Company_Category
    FROM
        Company_job_count
    JOIN 
        company_dim
    ON  
        company_dim.company_id = Company_job_count.company_id;

-- looking for top 5 skills for work from home
WITH Remote_Skills_Count AS(
SELECT
    skills.skill_id,
    Count(*) as JobCount
FROM    
    skills_job_dim as skills
JOIN
    job_postings_fact as jobs
ON  
    jobs.job_id = skills.job_id
WHERE
    jobs.job_work_from_home = TRUE
GROUP BY
    skills.skill_id
)

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    Remote_Skills_Count.JobCount
FROM 
    skills_dim
JOIN
    Remote_Skills_Count
ON  
    skills_dim.skill_id = Remote_Skills_Count.skill_id
ORDER BY
    3 DESC
LIMIT 
    5;

