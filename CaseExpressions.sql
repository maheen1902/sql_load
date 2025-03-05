-- Looking for remote,locate,onsite jobs

SELECT 
    Count(job_id),
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    End job_location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    job_location_category;


-- Bucketing jobs wrt to salaries for data analyst jobs

SELECT 
    Count(job_id),
    CASE
        WHEN salary_year_avg > 100000 THEN 'High'
        WHEN salary_year_avg > 50000 THEN 'Standard'
        ELSE 'Low'
    End Avg_salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    Avg_salary_category
ORDER BY
    1;