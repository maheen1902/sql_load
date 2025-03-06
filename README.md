# Introduction
 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.
 
🔍 SQL queries? Check them out here: [project_Files](/Project_Files/)

# Background
The motivation behind this project was to deepen my understanding of SQL and database management. I wanted to practice working with large datasets, optimize queries, and improve my data analysis techniques. This project serves as a hands-on approach to learning and implementing SQL best practices.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
Visual Studio Code: My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT	
	job_id,
    company_dim.name as Company_name,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date
FROM 
    job_postings_fact
Left JOIN
    company_dim
ON
    company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg is NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT
    10;
```
#### Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
With Top_paying_Jobs AS(
    SELECT	
	job_id,
    company_dim.name as Company_name,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date
FROM 
    job_postings_fact
Left JOIN
    company_dim
ON
    company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg is NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT
    10
)

SELECT 
    Top_paying_Jobs.Company_name,
    skills_dim.skills as SkillRequired,
	Top_paying_Jobs.job_title,
	Top_paying_Jobs.job_location,
	Top_paying_Jobs.job_schedule_type,
	Top_paying_Jobs.salary_year_avg,
	Top_paying_Jobs.job_posted_date
FROM
    Top_paying_Jobs
LEFT JOIN
    skills_job_dim
ON  
    skills_job_dim.job_id = Top_paying_Jobs.job_id
LEFT JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    Top_paying_Jobs.salary_year_avg DESC;
```

#### Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. 
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
With DataAnalyst_Jobs_with_skills AS(
SELECT
    job_title,
    skills_dim.skills as SkillRequired,
    job_location,
    job_schedule_type,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim
ON  
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title = 'Data Analyst')


SELECT
    SkillRequired,
    Count(*) AS NumofJobs
FROM
    DataAnalyst_Jobs_with_skills
GROUP BY
    SkillRequired
ORDER BY
    NumofJobs DESC
LIMIT
    10;
```
#### Here's the breakdown of the most demanded skills for data analysts in 2023

- **SQL and Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming and Visualization Tools** like Python, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT	
    skills_dim.skills as Skill_Name,
    ROUND(AVG(salary_year_avg)) as AvgSalary
FROM 
    job_postings_fact
LEFT JOIN
    skills_job_dim
ON
    skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN  
    skills_dim
ON
    skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    salary_year_avg is NOT NULL
    AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    AvgSalary DESC
LIMIT
    10;
```
#### Here's a breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
#### Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
-**Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.
# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- 🧩 **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- 📊 **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- 💡 **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusion
## Insights
From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
- **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
- **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
- **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
## Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.