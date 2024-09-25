-- Analysis of Company Employee Data Project
-- Data and First 6 Questions Obtained from DataFrenchy Academy
            
-- The goal is to analyze a company's employee data to bring insights to stakeholders.

-- Questions to Answer:
-- 1. Find the employee who has been with the company the longest.
-- 2. List all employees who work in a city different from their department's main location.
-- 3. List departments and the number of employees in each city.
-- 4. Rank employees based on their hire date (seniority) within each department.
-- 5. Find employees who are in the top 5 highest earners in the company.
-- 6. Classify employees based on their salary levels into three categories: Low, Medium, and High. Below 60k, Low, between 60k and 90k Medium, above 90k High.

-- ____________________________________________________________________________________________________________________________________________________________
-- Overview of Data
SELECT *
FROM employee;

SELECT *
FROM department;

-- Join Tables
SELECT*
FROM employee e
JOIN department d 
	ON e.id = d.id
;
-- ____________________________________________________________________________________________________________________________________________________________
-- 1. Find the employee who has been with the company the longest.
-- Convert Text to Date
SELECT STR_TO_DATE(hire_date, '%m/%d/%Y')
FROM employee
;

UPDATE employee
SET hire_date = STR_TO_DATE(hire_date, '%m/%d/%Y')
;

ALTER TABLE employee
MODIFY COLUMN hire_date DATE
;

SELECT first_name, last_name, hire_date, TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_employed
FROM employee
ORDER BY hire_date
LIMIT 1
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 2. List all employees who work in a city different from their department's main location which is in Cleveland, Ohio.
SELECT *
FROM employee e
JOIN department d 
	ON e.id = d.id
WHERE location_city <> 'Cleveland'
AND location_state <> 'Ohio'
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 3. List departments and the number of employees in each city.
SELECT location_city, department, COUNT(e.id) AS number_employees
FROM employee e
JOIN department d 
	ON e.id = d.id
GROUP BY location_city, department
ORDER BY location_city, department, number_employees
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 4. Rank employees based on their hire date (seniority) within each department. 1 is the highest level.
SELECT first_name, last_name, department, hire_date,
RANK() OVER(PARTITION BY department ORDER BY hire_date) AS seniority_level
FROM employee e
JOIN department d 
	ON e.id = d.id
ORDER BY department, seniority_level
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 5. Find employees who are in the top 5 highest earners in the company.
-- Remove $ and ',' Then Convert To Int
SELECT TRIM(REPLACE(REPLACE(salary, '$', ''), ',', ''))
FROM department
;

UPDATE department
SET salary = TRIM(REPLACE(REPLACE(salary, '$', ''), ',', ''))
;

ALTER TABLE department
MODIFY salary INT
;

SELECT first_name, last_name, salary
FROM employee e
JOIN department d 
	ON e.id = d.id
ORDER BY salary DESC
LIMIT 5
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 6. Classify employees based on their salary levels into three categories: Low, Medium, and High. Below 60k, Low, between 60k and 90k Medium, above 90k High.
SELECT first_name, last_name, salary,
CASE
	WHEN salary > 90000 THEN 'High'
    WHEN salary BETWEEN 60000 AND 90000 THEN 'Medium'
    WHEN salary < 60000 THEN 'Low'
END AS salary_level
FROM employee e
JOIN department d 
	ON e.id = d.id
;

-- ____________________________________________________________________________________________________________________________________________________________
                  -- Findings
		-- 1. Merlina Wilstead has been at the company the longest and was hired on 1987-12-10.  She has worked there for 36 years as of 2024-09-25.
        -- 2. There are 4189 employees that don't work in Cleveland, Ohio.  The full list can be queried above.
        -- 3. The full query can be found above. 
        -- 4. The full query can be found above. 
        -- 5. The top 5 earners in the company are:
					-- 1. Jerri Demangeon with a salary of $119,999
                    -- 2. Isaak Bourdon with a salary of $119,992
                    -- 3. Hesther Dealtry with a salary of $119,991
                    -- 4. Aurlie Becaris with a salary of $119,985
                    -- 5. Willetta Lelle with a salary of $119,984
		-- 6. The full query can be found above.
        
        
-- ____________________________________________________________________________________________________________________________________________________________
-- A few bonus questions I'm interested in:
-- 1. What is the average salary for each department? Rank the departments by highest earning.
-- 2. Do those working at Headquarters make more than those Remote on average?
-- 3. What is the ranking of Job Titles within each Department based on average Salary?

-- ____________________________________________________________________________________________________________________________________________________________
-- 1. What are the top 3 and bottom 3 departments based on average salary with all results in one table?
WITH top_3 AS
(
SELECT department, AVG(salary) AS average_salary,
RANK() OVER(ORDER BY AVG(salary) DESC) AS salary_rank,
"Highest" AS Label
FROM employee e
JOIN department d 
	ON e.id = d.id
GROUP BY department
ORDER BY salary_rank
LIMIT 3
), bottom_3 AS 
(
SELECT department, AVG(salary) AS average_salary,
RANK() OVER(ORDER BY AVG(salary)) AS salary_rank,
"Lowest" AS Label
FROM employee e
JOIN department d 
	ON e.id = d.id
GROUP BY department
ORDER BY salary_rank
LIMIT 3
)
SELECT department, average_salary, Label, salary_rank
FROM top_3

UNION ALL

SELECT department, average_salary, Label, salary_rank
FROM bottom_3
;

-- ____________________________________________________________________________________________________________________________________________________________
-- 2. Do those working at Headquarters make more than those Remote on average?
SELECT conditions, AVG(salary) AS average_salary
FROM department
GROUP BY conditions;

-- ____________________________________________________________________________________________________________________________________________________________
-- 3. What are the top ranking Job Titles for each Department based on average Salary? Rank those top ranking Job Titles by average Salary.
WITH sal_rank AS
(
SELECT department, jobtitle, AVG(salary) AS average_salary,
RANK() OVER(PARTITION BY department ORDER BY AVG(salary) DESC) AS salary_rank
FROM employee e
JOIN department d 
	ON e.id = d.id
GROUP BY department, jobtitle
ORDER BY department, salary_rank
)
SELECT department, jobtitle, average_salary,
RANK() OVER(ORDER BY average_salary DESC) AS top_job_titles_ranked
FROM sal_rank
WHERE salary_rank = 1
ORDER BY average_salary DESC
;

-- ____________________________________________________________________________________________________________________________________________________________
                  -- Additional Findings
		-- 1. Results show the Top 3 highest average salary departments and the Bottom 3.  Each show what category they are in and their rank within that category.
					--      Department            Average Salary     Label     Rank
                    -- Research and Development	  86134.5470		Highest		1
					-- Business Development	      85463.3002		Highest		2
					-- Product Management	      85091.8674		Highest		3
					-- Auditing	                  83848.7115		Lowest		1
					-- Marketing	              83944.9494		Lowest		2
					-- Training	                  84029.9326		Lowest		3
        -- 2. Headquarters Workers make an average of $84,764.08 while Remote Workers make an average of $84,556.39 so there is not a big difference.
        -- 3. Results show the top earning Job Titles for each Department and ranks them based on Average Salary:
					-- department                  job title        average salary  salary rank
                    -- Auditing	                Marketing Analyst	    96629.2500	     1
					-- Product Management	    Marketing Analyst	    90241.2167	     2
					-- Legal	                Product Analyst	        89316.9000	     3
					-- Services	                Product Analyst	        89168.9518	     4
					-- Research and Development	Financial Analyst	    89071.0909	     5
					-- Business Development	    Product Analyst	        88051.0980	     6
					-- Support	                Financial Analyst	    87862.4571	     7
					-- Marketing	            Product Analyst	        86998.8222	     8
					-- Human Resources	        Business Analyst	    86819.2450	     9
					-- Training	                Data Scientist	        86320.0054	     10
					-- Engineering	            Supply Chain Analyst	85951.1599	     11
					-- Sales	                HR Analyst	            85919.5814	     12
					-- Accounting	            HR Analyst	            85557.9965	     13
						

