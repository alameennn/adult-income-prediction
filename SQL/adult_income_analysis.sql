/*
Project: Adult Income Prediction Using Machine Learning

SQL Workflow:
1. Database Setup
2. Data Understanding
3. Business Analysis
4. Data Cleaning

*/

-- 1. Database Setup

CREATE DATABASE employee_salary_db;
USE employee_salary_db;

-- 2. Data Understanding

-- 2.1 Preview the Dataset

SELECT * 
FROM adult_income 
LIMIT 5;

-- 2.2 Total Records

SELECT COUNT(*) AS  total_records
FROM adult_income;

-- 2.3 Dataset Structure

DESCRIBE adult_income;

-- 2.4 Missing Value Analysis

SELECT
	SUM(workclass = '?') AS workclass_missing,
	SUM(occupation = '?') AS occupation_missing,
	SUM(`native-country` = '?') AS native_country_missing
FROM adult_income;

-- 2.5 Duplicate Record Analysis

SELECT COUNT(*) AS duplicate_records
FROM 
(
	SELECT *,
	COUNT(*) AS record_count
    FROM adult_income
    GROUP BY
		age,
        workclass,
        fnlwgt,
        education,
        `educational-num`,
        `marital-status`,
        occupation,
        relationship,
        race,
        gender,
        `capital-gain`,
        `capital-loss`,
        `hours-per-week`,
        `native-country`,
        income
        HAVING COUNT(*) > 1    
) AS duplicates;

-- 2.6 Income Distribution

SELECT 
	income,
    COUNT(*) AS total_people
FROM adult_income
GROUP BY income;

-- 2.7 Income Distribution Percentage

SELECT
    income,
    COUNT(*) AS total_people,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM adult_income), 2) AS percentage
FROM adult_income
GROUP BY income;

-- 2.8 Education and Income Distribution

SELECT 
	education,
	income,
    COUNT(*) AS total_people
FROM adult_income
GROUP BY education, income
ORDER BY education, income;

-- 3. Business Analysis

-- 3.1 Education vs High Income

SELECT
    education,
    COUNT(*) AS total_people,
    SUM(income = '>50K') AS high_income,
    ROUND(SUM(income = '>50K') * 100.0 / COUNT(*), 2) AS high_income_percentage
FROM adult_income
GROUP BY education
ORDER BY high_income_percentage DESC;

-- 3.2 Occupation vs High Income

SELECT 
	occupation,
    COUNT(*) AS total_people,
    SUM(income = '>50k') AS high_income,
    ROUND(SUM(income = '>50K') * 100.0/ COUNT(*),2)AS high_income_percentage
FROM adult_income
WHERE occupation <> '?'
GROUP BY occupation
ORDER BY high_income_percentage DESC;

-- 3.3 Workclass vs High Income

SELECT 
	workclass,
    COUNT(*) AS total_people,
    SUM(income = '>50k') AS high_income,
    ROUND(SUM(income='>50k') * 100.0 /COUNT(*) ,2) AS high_income_percentage
FROM adult_income
WHERE workclass <> '?'
GROUP BY workclass
ORDER BY high_income_percentage DESC;

-- 3.4 Marital Status vs High Income

SELECT
	`marital-status`,
    COUNT(*) AS total_people,
    SUM(income = '>50K') AS high_income,
    ROUND(SUM(income = '>50K') * 100.0 / COUNT(*), 2) AS high_income_percentage
FROM adult_income
GROUP BY `marital-status`
ORDER BY high_income_percentage DESC;

-- 3.5 Age Analysis
    
SELECT
	income,
    ROUND(AVG(age), 2) AS average_age,
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age
FROM adult_income
GROUP BY income;

-- 3.6 Working Hours Analysis

SELECT
    income,
    ROUND(AVG(`hours-per-week`), 2) AS average_hours,
    MIN(`hours-per-week`) AS minimum_hours,
    MAX(`hours-per-week`) AS maximum_hours
FROM adult_income
GROUP BY income;

-- 3.7 Capital Gain Analysis

SELECT
    income,
    ROUND(AVG(`capital-gain`), 2) AS average_capital_gain,
    MAX(`capital-gain`) AS maximum_capital_gain
FROM adult_income
GROUP BY income;

-- 3.8 Age Group Analysis

SELECT
    CASE
        WHEN age < 30 THEN 'Young (17-29)'
        WHEN age BETWEEN 30 AND 45 THEN 'Adult (30-45)'
        WHEN age BETWEEN 46 AND 60 THEN 'Middle Age (46-60)'
        ELSE 'Senior (60+)'
    END AS age_group,
    COUNT(*) AS total_people,
    SUM(income = '>50K') AS high_income,
    ROUND(SUM(income = '>50K') * 100.0 / COUNT(*), 2) AS high_income_percentage
FROM adult_income
GROUP BY age_group
ORDER BY high_income_percentage DESC;

-- 3.9 Occupations Above Average High-Income Percentage

WITH occupation_income AS (
	SELECT 
		occupation,
        COUNT(*) AS total_people,
        SUM(income = '>50k') AS high_income,
        ROUND(SUM(income = '>50k') * 100.0 / COUNT(*),2) AS high_income_percentage
	FROM adult_income
    WHERE occupation <> '?'
    GROUP BY occupation
)

SELECT *
FROM occupation_income
WHERE high_income_percentage > 
(
	SELECT AVG(high_income_percentage)
	FROM occupation_income
)
ORDER BY high_income_percentage DESC;

-- 3.10 Occupation Ranking

SELECT
    occupation,
    COUNT(*) AS total_people,
    SUM(income = '>50K') AS high_income,
    ROUND(SUM(income = '>50K') * 100.0 / COUNT(*), 2) AS high_income_percentage,
    RANK()OVER(
		ORDER BY ROUND(SUM(income = '>50k') * 100 / COUNT(*),2) DESC
    ) AS occupation_rank
FROM adult_income
WHERE occupation <> '?'
GROUP BY occupation;

-- 3.11 Employees Working Above Average Hours

SELECT
    age,
    occupation,
    `hours-per-week`,
    income
FROM adult_income
WHERE `hours-per-week`>
(
	SELECT AVG(`hours-per-week`)
    FROM adult_income
)
ORDER BY `hours-per-week` DESC;

-- 4. Data Cleaning

-- 4.1 Create Working Dataset

CREATE TABLE adult_income_clean AS 
SELECT *
FROM adult_income;

-- 4.2 Missing Value Verification

SELECT
    SUM(workclass = '?') AS missing_workclass,
    SUM(occupation = '?') AS missing_occupation,
    SUM(`native-country` = '?') AS missing_native_country
FROM adult_income_clean;

-- 4.3 Missing Value Relationship Analysis

SELECT
    SUM(workclass = '?' AND `native-country` = '?') AS workclass_country,
    SUM(occupation = '?' AND `native-country` = '?') AS occupation_country,
    SUM(workclass = '?' AND occupation = '?' AND `native-country` = '?') AS all_three_missing
FROM adult_income_clean;

-- 4.4 Handling Missing Workclass and Occupation

DELETE FROM adult_income_clean
WHERE workclass = '?'
   OR occupation = '?';
   
-- 4.5 Handling Missing Native Country

UPDATE adult_income_clean
SET `native-country` = 'Unknown'
WHERE `native-country` = '?';

SELECT
    SUM(`native-country` = '?') AS missing_country
FROM adult_income_clean;

-- 4.6 Duplicate Record Detection

SELECT
    age,
    workclass,
    fnlwgt,
    education,
    `educational-num`,
    `marital-status`,
    occupation,
    relationship,
    race,
    gender,
    `capital-gain`,
    `capital-loss`,
    `hours-per-week`,
    `native-country`,
    income,
    COUNT(*) AS duplicate_count
FROM adult_income_clean
GROUP BY
    age,
    workclass,
    fnlwgt,
    education,
    `educational-num`,
    `marital-status`,
    occupation,
    relationship,
    race,
    gender,
    `capital-gain`,
    `capital-loss`,
    `hours-per-week`,
    `native-country`,
    income
HAVING COUNT(*) > 1;

-- 4.7 Create Final Clean Dataset

CREATE TABLE adult_income_final AS
SELECT DISTINCT *

FROM adult_income_clean;

SELECT COUNT(*)
FROM adult_income_final;

/*
The cleaned dataset (adult_income_final) is exported to Google Colab for machine learning.
*/