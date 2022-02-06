-------------------------------------------------------------------------------
-- EXERCISE 1: 
-- Select all data from the “departments” table.
-------------------------------------------------------------------------------
SELECT *
FROM emp.departments;


-------------------------------------------------------------------------------
-- EXERCISE 2: 
-- Select the information from the “dept_no” column of the “departments” table.
-------------------------------------------------------------------------------
SELECT dept_no
FROM emp.departments;


-------------------------------------------------------------------------------
-- EXERCISE 3: 
-- Select first name and gender from the “employees” table of people whose
-- first name is “Mary”. 
-- 224 rows
-------------------------------------------------------------------------------
SELECT first_name, gender
FROM emp.employees
WHERE first_name = "Mary";


-------------------------------------------------------------------------------
-- EXERCISE 4: 
-- Select emp_no and from datefrom the “titles” table for people with the title
-- 'Engineer' and where the hire date is before 18th July 2002
-- 114967 rows
-------------------------------------------------------------------------------
SELECT emp_no, from_date
FROM emp.titles
WHERE title = "Engineer"
    AND from_date < "2002-07-18";


-------------------------------------------------------------------------------
-- EXERCISE 5: 
-- Retrieve first_name and birth date of all male employees whose last name is
-- Swan.
-- 126 rows
-------------------------------------------------------------------------------
SELECT first_name, birth_date
FROM emp.employees
WHERE gender = "M"
    AND last_name = "Swan";


-------------------------------------------------------------------------------
-- EXERCISE 6:
-- Retrieve all data of employees whose 
-- first name is Aruna or whose last name is Swan.
-- 402 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE first_name = "Aruna"
    OR last_name = "Swan";


-------------------------------------------------------------------------------
-- EXERCISE 7:
-- Retrieve all data of male employees whose 
-- first name is Aruna or whose last name is Swan.
-- 251 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE gender = 'M'
    AND (
        first_name = "Aruna"
        OR last_name = "Swan"
        );


-------------------------------------------------------------------------------
-- EXERCISE 8:
-- Retrieve a table last_name all of employees whose first name is Gao or
-- Herbert. Don't use the OR operator
-- 497 rows
-------------------------------------------------------------------------------
SELECT last_name
FROM emp.employees
WHERE first_name IN ("Gao", "Herbert");


-------------------------------------------------------------------------------
-- EXERCISE 9:
-- Extract all records from the ‘employees’ table, except for those with 
-- employees named John, Mark, Elvis, Gao or Jacob
-- 299318 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE first_name NOT IN ("Denis", "John", "Mark", "Gao", "Jacob")


-------------------------------------------------------------------------------
-- EXERCISE 10: 
-- Working with the “employees” table, use the LIKE operator to select the data
-- about all individuals, whose first name starts with “Anne”, 
-- specify that the name can be succeeded by any sequence of characters.
-- 679 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE first_name LIKE ("Anne%");


-------------------------------------------------------------------------------
-- EXERCISE 11:
-- Retrieve a table with all employees who have been hired in the year 2000
-- 13 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE hire_date BETWEEN "2000-01-01" AND "2000-12-31";


-------------------------------------------------------------------------------
-- EXERCISE 12:
-- Select all the information from the “salaries” table regarding contracts 
-- from 68,000 to 72,000 dollars per year
-- 69245 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.salaries
WHERE salary BETWEEN 68000 AND 72000;


-------------------------------------------------------------------------------
-- EXERCISE 13: Retrieve a table with all individuals whose employee number
-- is not between ‘10005’ and ‘10012’
-- 300016 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE emp_no NOT BETWEEN 10005 AND 10012;


-------------------------------------------------------------------------------
-- EXERCISE 14:
-- Get data for all female employees born between 1952 and 1954
-- or born between 1962 and 1964
-- 54446 rows
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE gender = 'F'
    AND (
        birth_date BETWEEN '1952-01-01' AND '1954-12-31'
        OR birth_date BETWEEN '1962-01-01' AND '1964-12-31'
        );


-------------------------------------------------------------------------------
-- EXERCISE 15: 
-- Retrieve a table with all the distinct titles
-- 7 rows
-------------------------------------------------------------------------------
SELECT DISTINCT title
FROM emp.titles;


-------------------------------------------------------------------------------
-- EXERCISE 17:
-- Which is the lowest employee number in the database?
-------------------------------------------------------------------------------
SELECT MIN(emp_no)
FROM emp.employees;


-------------------------------------------------------------------------------
-- EXERCISE 18:
-- Which is the highest employee number in the database?
-------------------------------------------------------------------------------
SELECT MAX(emp_no)
FROM emp.employees;


-------------------------------------------------------------------------------
-- EXERCISE 19: 
-- What is the average annual salary paid to employees who started after the
-- 1st of January 1997?
-- 67717.74
-------------------------------------------------------------------------------
SELECT AVG(salary)
FROM emp.salaries
WHERE from_date > "1997-01-01";


-------------------------------------------------------------------------------
-- EXERCISE 20: 
-- What are the most common titles? Order from most to least common
-------------------------------------------------------------------------------
SELECT title
    ,COUNT(*) AS ct
FROM emp.titles
GROUP BY title
ORDER BY ct DESC;

-------------------------------------------------------------------------------
-- EXERCISE 21:
-- How many current contracts with a value higher than or equal to $100,000
-- have been registered in the salaries table?
-- Answer: 5929
-------------------------------------------------------------------------------
SELECT COUNT(*) AS no_contracts_abv_100000
FROM emp.salaries
WHERE salary >= 100000
    AND to_date = '9999-01-01';


-------------------------------------------------------------------------------
-- EXERCISE 22:
-- How many people have been hired per year?
-------------------------------------------------------------------------------
SELECT EXTRACT(year FROM hire_date) AS hire_year
    ,count(*) AS num_hired
FROM emp.employees
GROUP BY hire_year;

-------------------------------------------------------------------------------
---------------------------------BONUS Questions-------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- BONUS 1: 
-- How many currently employed people earn more than 80000?
-- 16775 rows
-------------------------------------------------------------------------------
SELECT salary
    ,COUNT(*) AS emps_with_salary
FROM emp.salaries
WHERE salary > 80000
    AND to_date = '9999-01-01'
GROUP BY salary
ORDER BY salary;

-------------------------------------------------------------------------------
-- BONUS 2: 
-- What's the average salaries for men/women currently employed?
-- You need to use JOIN
-------------------------------------------------------------------------------
SELECT e.gender
    ,AVG(s.salary) AS avg_salary
FROM emp.employees AS e
INNER JOIN emp.salaries AS s
    ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
GROUP BY e.gender;


-------------------------------------------------------------------------------
-- BONUS 3: 
-- What titles have the highest paying average salaries?
-- You need to use JOIN
-------------------------------------------------------------------------------
SELECT t.title
    ,AVG(s.salary) AS avg_salary
FROM emp.titles AS t
INNER JOIN emp.salaries AS s
    ON t.emp_no = s.emp_no
GROUP BY t.title
ORDER BY avg_salary DESC;


-------------------------------------------------------------------------------
-- BONUS 4: 
-- How many employees are there in each of the following 4 categories?
    -- Male Staff
    -- Female Staff
    -- Male Manager
    -- Female Manager
-- You need to use JOIN
-------------------------------------------------------------------------------
SELECT e.gender
    ,t.title
    ,COUNT(*) as no_of
FROM emp.employees AS e
INNER JOIN emp.titles AS t
    ON e.emp_no = t.emp_no
GROUP BY e.gender, t.title;

-------------------------------------------------------------------------------
-- BONUS 5: 
-- What's the average salaries for each of the following 4 categories:
    -- Male Engineer
    -- Female Engineer
    -- Male Assistant Engineer
    -- Female Assistant Engineer
-- You need to use multiple JOINs
-------------------------------------------------------------------------------
SELECT e.gender
    ,AVG(s.salary) AS avg_salary,
    t.title
FROM emp.employees AS e
INNER JOIN emp.salaries AS s
    ON e.emp_no = s.emp_no
INNER JOIN emp.titles as t 
    ON t.emp_no = e.emp_no
WHERE s.to_date = '9999-01-01'
GROUP BY e.gender, t.title;