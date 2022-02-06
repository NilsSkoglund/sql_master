-------------------------------------------------------------------------------
-- Introduction to SQL
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introduction to the BigQuery UI
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introduce the database "emp"
    -- emp is the name of the database
    -- which is made up of a bunch of different tables
    -- Have a look around inside BigQuery
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Now, moving into specific tables and writing queries
-------------------------------------------------------------------------------


-- Look at an overview of the departments table, then move on to the query
    -- SCHEMA tab: STRING = Text
    -- Preview tab: ...

-- 9 rows returned. 9 different departments
SELECT * -- select all columns
FROM emp.departments;


-- Look at an overview of the employees table, then move on to the query below
    -- SCHEMA TAB: DATE = DATE, INTEGER (Heltal) =  Numerical data

-- 300 000+ rows returned
SELECT *
FROM emp.employees;

-------------------------------------------------------------------------------
------------------------ controlling execution of code ------------------------
-- ctrl + e/enter to execute
-- if you execute without highlighting text, all code will be executed
-- In bigquery, you can then choose which table you want to look at
-- if you highlight, only the highlighted code will be executed
-- and only 1 table will be returned
-- A sql query always returns a table (with the "answer" to your query)
-- A query ends with a semicolon
-------------------------------------------------------------------------------


-- in the select statement you can specify which columns you want to look at
SELECT
    first_name
    ,last_name
FROM emp.employees;

-------------------------------------------------------------------------------
-- Introducing ORDER BY and DESC
-------------------------------------------------------------------------------
SELECT first_name
    ,last_name
FROM emp.employees
ORDER BY first_name;


SELECT first_name
    ,last_name
FROM employees.employees
ORDER BY first_name DESC; -- DESC orders descendingly


SELECT first_name
    ,last_name
FROM emp.employees
ORDER BY first_name
    ,last_name;
    
SELECT first_name
    ,last_name
FROM emp.employees
ORDER BY first_name DESC
    ,last_name DESC;
    

-------------------------------------------------------------------------------
---------------------------- Readability Interlude ----------------------------
-- Code is read 10x more than it is written

-- You can run the code below. 
select first_name, last_name from employees.employees order by first_name DESC, last_name DESC;
-- But it is not nice nor efficient to read

-------------------------------------------------------------------------------
-- Quick introduction to SQL formater
-- https://poorsql.com/
-- indent string: \s\s\s\s
-- max line width: 79
-------------------------------------------------------------------------------


-- Copy & paste query above into formatter ^ 

-- Will give you the structure shown below. Much more readable

SELECT first_name
    ,last_name
FROM employees.employees
ORDER BY first_name DESC
    ,last_name DESC;
    
-------------------------------------------------------------------------------
----------------------- Readability Interlude finished ------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introducing date functions
-- often we have date data in our datasets. To work with them properly and
-- efficiently, we can make use of date functions.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introducing EXTRACT()
-- syntax: EXTRACT(part FROM date_expression)
-- We use this to "extract" a part of a date
-- Year, month, week or day for example
-------------------------------------------------------------------------------

-- Starting with the hire date
SELECT hire_date
FROM emp.employees;

-- Then "extracting" the year when they were hired
-- The returned output is a number, not a date
SELECT EXTRACT(year FROM hire_date) AS year_hired
FROM emp.employees;

-- Now "extracting" only the month when they were hired
SELECT EXTRACT(month FROM hire_date) AS month_hired
FROM emp.employees;

-- Let's say we want the year and the month...

-------------------------------------------------------------------------------
-- introducing DATE_TRUNC()
-- syntax: DATE_TRUNC(date_expression, date_part)
-- You can think of it as "rounding" a date
-- Returns a date (compared to EXTRACT() that returns a number)
-------------------------------------------------------------------------------

-- Year, month when they were hired. Leaving YYYY-MM-01
SELECT DATE_TRUNC(hire_date, month) AS year_month_hired
FROM emp.employees
ORDER BY year_month_hired;

-------------------------------------------------------------------------------
-- introducing DATE_DIFF()
-- Calculate difference between two date
-- DATE_DIFF(date_expression_a, date_expression_b, date_part)

SELECT DATE_DIFF(hire_date, birth_date, YEAR)  
FROM emp.employees;

SELECT DATE_DIFF(hire_date, birth_date, YEAR) 
    ,DATE_DIFF(hire_date, birth_date, DAY) 
FROM emp.employees;
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- finishing date functions intro with some documentation
-- google: SQL Date Functions (look at results)
-- Then google: SQL Date functions BigQuery
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions
-------------------------------------------------------------------------------

-- End of date functions

-------------------------------------------------------------------------------
-- Introducing WHERE 
-- The WHERE clause is used for filtering, extracting only those records that 
-- fulfill a specified (boolean) condition.
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE first_name = "Maria";

-- returns 246 rows
SELECT *
FROM emp.employees
WHERE first_name = "Elvis";


-- This is how it works for dates.
SELECT *
FROM emp.employees
WHERE birth_date > "1964-01-01";


-- To make it inclusive.
SELECT *
FROM emp.employees
WHERE birth_date >= "1964-01-01";


-------------------------------------------------------------------------------
-- Introducing AND
-- To require two boolean expressions to be True
-------------------------------------------------------------------------------
-- returns 150 rows
SELECT *
FROM emp.employees
WHERE first_name = "Elvis"
    AND gender = "M";


-- returns 6 rows
SELECT *
FROM emp.employees
WHERE first_name = "Elvis"
    AND gender = "M"
    AND birth_date > "1964-01-01";


-------------------------------------------------------------------------------
----------------------------- Data Types Interlude ----------------------------
-------------------------------------------------------------------------------
-- For now you only have to care about three different "data types"
    -- Text
    -- Date
    -- Numbers

SELECT *
FROM emp.employees
WHERE first_name = "Elvis"
    AND gender = "M"
    AND birth_date > "1964-01-01"
    AND emp_no < 100000;
    
-- Nonsensical filtering conditions, but we are focusing on the Syntax
-- (ask students if they know what syntax means)
    
-- Syntax (grammer)
    -- Text data: inside of quotation marks
    -- Date data: inside of quotation marks
    -- Numerical data: no quotation marks
    
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------------------------ Data Types Interlude finished ------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- OR
-- To require AT LEAST ONE of the boolean expressions to be True
-------------------------------------------------------------------------------
-- Returns 246 rows
SELECT *
FROM emp.employees
WHERE first_name = "Elvis";


-- Returns 485 rows
SELECT *
FROM emp.employees
WHERE first_name = "Elvis"
    OR first_name = "Maria";


-- Mind the parenthesis when using multiple boolean expressions
-- Returns 4 rows
SELECT *
FROM emp.employees
WHERE ( 
        first_name = 'Elvis'
        OR first_name = 'Maria'
        )
    AND birth_date > "1964-12-01";


-- 249 rows, because now the query returns People named
-- 1) Elvis OR 
-- 2) people named Maria who are born after 1964-12-01
SELECT *
FROM emp.employees
WHERE first_name = 'Elvis'
    OR first_name = 'Maria'
    AND birth_date > "1964-12-01";


-------------------------------------------------------------------------------
-- IN / NOT IN
-------------------------------------------------------------------------------
-- Returns 300 024 rows
SELECT *
FROM emp.employees;


-- Returns 484 rows
SELECT *
FROM emp.employees
WHERE first_name IN ("Maria", "Elvis");


-- Returns (300 024 - 484) rows
SELECT *
FROM emp.employees
WHERE first_name NOT IN ("Maria", "Elvis");


-------------------------------------------------------------------------------
-- BETWEEN
-- important! The BETWEEN operator is inclusive
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE hire_date BETWEEN '1999-01-01' AND '2000-01-01';


SELECT *
FROM emp.employees
WHERE hire_date BETWEEN '1999-01-01' AND '2000-01-01'
    AND first_name = "Elvis";

-------------------------------------------------------------------------------
-- LIKE
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE first_name = "Maria";


-- Returns 7954 rows. Names beginning with "Mar"
SELECT *
FROM emp.employees
WHERE first_name LIKE ('Mar%');


-- Returns 1630 rows. Names beginning with "Mar" follow by 1 character
SELECT *
FROM emp.employees
WHERE first_name LIKE ('Mar_');



/*
We have now looked at a bunch of Keywords we can use in the WHERE STATEMENT:

    - AND
    - OR
    - IN / NOT IN
    - BETWEEN
    - LIKE

Let's move past the WHERE statement!
Next up...
*/
-------------------------------------------------------------------------------
-- Introducing DISTINCT
-- Returns the unique values for a column
-------------------------------------------------------------------------------
-- 2 unique genders
SELECT DISTINCT (gender)
FROM emp.employees;


-- 1275 unique Names
SELECT DISTINCT (first_name)
FROM emp.employees;


-------------------------------------------------------------------------------
-- Introducing AGGREGATE FUNCTIONS
-- COUNT, MIN, MAX, AVG, SUM
-------------------------------------------------------------------------------
SELECT *
FROM emp.salaries;


-- Kind of meaningless aggregate in this case, returns no. of rows
SELECT COUNT(*)
FROM emp.salaries;


-- COUNT is more useful in other situations. For example combined with WHERE
-- 32205 entries
SELECT COUNT(*)
FROM emp.salaries
WHERE salary < 70000;

-------------------------------------------------------------------------------
-- THEORY ALERT! 
-- Introducing order of execution in a query. 
-- In this query, only looking at FROM > WHERE > SELECT
-- Will set students up nicely for more in depth order of execution later on. 
-- Slides: 02 Intro SQL Order of Execution
-------------------------------------------------------------------------------

-- Back to coding. Continuing with aggregate functions

-- MAX
SELECT MAX(salary)
FROM emp.salaries;


-- MIN
SELECT MIN(salary)
FROM emp.salaries;


-- AVG
SELECT AVG(salary)
FROM emp.salaries;


-- SUM
SELECT SUM(salary)
FROM emp.salaries;


-------------------------------------------------------------------------------
-- ALIAS AKA ... AS ...
-- We have already used it when doing date functions
-- AS ... is commonly used to give data a more meaningful/readable name
-------------------------------------------------------------------------------

-- In this case, without the AS ... 
-- it names it f0_
-- bad name!
SELECT MAX(salary)
FROM emp.salaries;

SELECT MAX(salary) AS max_salary
FROM emp.salaries;
-- good name!


SELECT AVG(salary) AS average_salary
FROM emp.salaries;


-------------------------------------------------------------------------------
-- Introducing GROUP BY
-- Always used together with Aggregate functions

-------------------------------------------------------------------------------
-- Counting no. of women and no. of men
SELECT gender
    ,COUNT(*) AS no_of
FROM emp.employees
GROUP BY gender;


-- no. of employees per title?

-- Preview titles to introduce students to the table

-- Further intro to the titles table with the query below
SELECT DISTINCT(title) 
FROM emp.titles;

-- final query
SELECT count(title) AS no_of
    ,title
    ,
FROM emp.titles
GROUP BY title;


-- Mini Challenge:
-- Calculate the number of employees in each department (use the dept_emp table)
SELECT dept_no
    ,COUNT(emp_no) AS employee_count
FROM emp.dept_emp
GROUP BY dept_no;


-------------------------------------------------------------------------------
-- Introducing HAVING
-------------------------------------------------------------------------------
-- Let's say we only want to look at departments with 20 000 or less employees
SELECT dept_no
    ,COUNT(*) AS employee_count
FROM emp.dept_emp
WHERE employee_count < 20000 -- This does not work
GROUP BY dept_no;


-- Instead of WHERE we have to use HAVING.
SELECT dept_no
    ,COUNT(*) AS employee_count
FROM emp.dept_emp
GROUP BY dept_no
HAVING employee_count < 20000;

-------------------------------------------------------------------------------
-- HAVING requires that a GROUP BY clause is present
-- HAVING is like WHERE but for values calculated from using group by
-------------------------------------------------------------------------------


-- Both WHERE + HAVING
-- Let's add a filter so we are...
-- ... only counting people who are still working in that department
SELECT dept_no
    ,COUNT(*) AS employee_count
FROM emp.dept_emp
WHERE to_date = "9999-01-01"
GROUP BY dept_no
HAVING employee_count < 20000;



-------------------------------------------------------------------------------
-- Question to students: What is the order of execution in this query?

-- Let students discuss for a few minutes

-- Correct answer: FROM > WHERE > GROUP BY + AGG CALCULATION > HAVING > SELECT
-------------------------------------------------------------------------------


-- Add in order by
SELECT dept_no
    ,COUNT(*) AS employee_count
FROM emp.dept_emp
WHERE to_date = "9999-01-01"
GROUP BY dept_no
HAVING employee_count < 20000
ORDER BY employee_count;
-------------------------------------------------------------------------------
-- Question to students: When is ORDER BY executed
-- Give students 10 sec to answer
-- correct answer: ORDER BY is the last statement to be executed
-------------------------------------------------------------------------------


------------------------------- Summary Time ----------------------------------
-- Slides: "SQL Query Core Components & Order of Execution"
-------------------------------------------------------------------------------