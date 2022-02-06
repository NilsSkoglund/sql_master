-------------------------------------------------------------------------------
-------------------------------- emp database ---------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--------------------------------- SQL Basics ----------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXERCISE 1:
-- Retrieve a table with all employees who have been hired ...
-- ... between 1995-2000
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXERCISE 2:
-- Select all the information from the “salaries” table regarding contracts 
-- from 68,000 to 72,000 dollars per year
-- 69245 rows
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXERCISE 3:
-- How many people have been hired per year?
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
------------------------------------- JOINs -----------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- Get the average salaries by department. 
-- Only include current contracts 

/*
title	avg_salary
Staff	77443.89375
Manager	79546.25
Engineer	67917.69456
Senior Staff	80582.5732
Senior Engineer	70845.22055
Technique Leader	67410.69555
Assistant Engineer	67740.15746
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- Filter the output table from the previous question so it only returns ...
-- ... titles with an average salary above 70000

/*
title	avg_salary
Staff	77443.89375
Manager	79546.25
Senior Staff	80582.5732
Senior Engineer	70845.22055
*/
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- We want to get the average management salary per department from high to low
-- (and we want the name of the department)

/*
department_name	avg_management_salary
Marketing	88371.68571
Sales	85738.76471
Research	77535.18182
Quality Management	70900.1875
Finance	70815.88889
Customer Service	64812.33333
Development	59658.11765
Production	56233.4
Human Resources	55919.46
*/
-------------------------------------------------------------------------------





-------------------------------------------------------------------------------
---------------------------------- Subqueries ---------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- EXERCISE 1: 
-- Select first_name & last_name
-- on all female managers
-- order by first name then last name

/*
first_name	last_name
Hilary	Kambil
Isamu	Legleitner
Karsten	Sigstam
Krassimir	Wegerle
Leon	DasSarma
Marjo	Giarratana
Peternela	Onuegbe
Rosine	Cools
Rutger	Hofmeyr
Shirish	Ossenbruggen
Tonny	Butterworth
Xiaobin	Spinelli
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXERCISE 2: 
-- Show the average, min and max number of employees in a department

-- use the dept_emp table and ...
-- ... make sure to only include rows where the to_date = "9999-01-01"

/*
min_emps	max_emps	
26680.44444	12437	61386
*/
-------------------------------------------------------------------------------




-------------------------------------------------------------------------------
-- EXERCISE 3: 
-- select all department names that currently have a female manager

/*
dept_name
Development
Finance
Human Resources
Research
*/
-------------------------------------------------------------------------------




