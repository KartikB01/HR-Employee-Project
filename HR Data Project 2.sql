SELECT *
FROM HumanResources

-- Data Hygiene and minor processing

-- Adding a full name column

SELECT CONCAT(first_name, ' ', last_name)
FROM HumanResources

ALTER TABLE HumanResources
ADD full_name nvarchar(50);

UPDATE HumanResources
SET full_name = CONCAT(first_name, ' ', last_name)

-- Normalizing date formats

UPDATE HumanResources
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%y'), '%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%y'), '%Y-%m-%d')
ELSE NULL END;


UPDATE HumanResources
SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%y'), '%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%y'), '%Y-%m-%d')
ELSE NULL END;


-- Finding Age from Birthdate

ALTER TABLE HumanResources
ADD age INT;

UPDATE HumanResources
SET age = DATEDIFF(year, birthdate, getdate())

SELECT MIN(age), MAX(age)
FROM HumanResources

-- ANSWERING SPECIFIC QUESTIONS

-- Gender Breakdown of Employees

SELECT gender, COUNT(*) AS Total_Employees
FROM HumanResources
WHERE termdate IS NULL
GROUP BY gender
ORDER BY Total_Employees DESC

-- Race Breakdown of Employees

SELECT race, COUNT(*) AS Total_Employees
FROM HumanResources
WHERE termdate IS NULL
GROUP BY race
ORDER BY Total_Employees DESC

-- Age Distribution of Employees

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		ELSE '55+'
	END AS Age_group,
	COUNT(*) AS count
	FROM HumanResources
	WHERE termdate IS NULL
	GROUP BY CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
		WHEN age >= 25 AND age <= 34 THEN '25-34'
		WHEN age >= 35 AND age <= 44 THEN '35-44'
		WHEN age >= 45 AND age <= 54 THEN '45-54'
		ELSE '55+'
	END 
	ORDER BY Age_group ASC;

-- Remote vs Office Employees

SELECT location, COUNT(*) AS Total_Employees
FROM HumanResources
WHERE termdate IS NULL
GROUP BY location
ORDER BY Total_Employees DESC

-- Gender distribution across departments/job titles 

SELECT department, jobtitle, gender, COUNT(*)
FROM HumanResources
WHERE termdate IS NULL
GROUP BY department, jobtitle, gender
ORDER BY department, jobtitle, gender

SELECT department, gender, COUNT(*) AS count
FROM HumanResources
WHERE termdate IS NULL
GROUP BY department, gender
ORDER BY department, gender

-- Department with the highest termination

SELECT department, COUNT(*) AS count, COUNT(
CASE WHEN termdate IS NOT NULL and termdate <= getdate() THEN 1 END) AS Term_count, ROUND((COUNT(
CASE WHEN termdate IS NOT NULL and termdate <= getdate() THEN 1 END)/COUNT(*)*100), 2) AS termination_rate
FROM HumanResources
GROUP BY department
ORDER BY termination_rate DESC;

-- Distribution of employees across location

SELECT location_state, COUNT(*) AS Total_Employees
FROM HumanResources
WHERE termdate IS NULL
GROUP BY location_state;





