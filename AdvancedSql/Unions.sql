-- Looking for jobs from the first 3 months that have avg salary >70k

SELECT *
FROM
(SELECT
    job_title_short,
    salary_year_avg,
    job_posted_date ::Date
FROM
    january_jobs

UNION

SELECT
    job_title_short,
    salary_year_avg,
    job_posted_date::Date
FROM
    feburary_jobs

UNION

SELECT
    job_title_short,
    salary_year_avg,
    job_posted_date::Date
FROM
    march_jobs)
    AS Quater1Postings
WHERE
    Quater1Postings.salary_year_avg > 70000
ORDER BY
    2 DESC;