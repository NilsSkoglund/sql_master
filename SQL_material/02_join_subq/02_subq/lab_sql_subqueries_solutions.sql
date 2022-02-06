-------------------------------------------------------------------------------
---------------------------------- Subqueries ---------------------------------
-------------------------------------------------------------------------------
-- Some of these questions you could answer with JOINs as well.
-- Try to solve them with subqueries instead.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXERCISE 1: 
-- Select first_name, last_name, gender, birth_date and hire date
-- on all managers
-------------------------------------------------------------------------------
SELECT *
FROM emp.employees
WHERE emp_no IN (
        SELECT emp_no
        FROM emp.dept_manager
        );

-------------------------------------------------------------------------------
-- EXERCISE 2: 
-- select all department names that currently have a female manager
-------------------------------------------------------------------------------
SELECT dept_name
FROM emp.departments
WHERE dept_no IN (
        SELECT dept_no
        FROM emp.dept_manager
        WHERE to_date = '9999-01-01'
            AND emp_no IN (
                SELECT emp_no
                FROM emp.employees
                WHERE gender = 'F'
                )
        );


-------------------------------------------------------------------------------
-- EXERCISE 3: 
-- Calculate the average number of employees working in a department.
-- Also show the min and max number of employees working in a department.
-------------------------------------------------------------------------------
SELECT avg(emp_count) AS avg_emps
    ,min(emp_count) AS min_emps
    ,max(emp_count) AS max_emps
FROM (
    SELECT count(*) AS emp_count
    FROM emp.dept_emp
    GROUP BY dept_no
    );


-------------------------------------------------------------------------------
-- EXERCISE 4:
-- Calculate per year how many people hired in that year are still working
-- in the company to date.
-------------------------------------------------------------------------------
SELECT EXTRACT(year FROM hire_date) AS year_hired
    ,count(*) AS still_working
FROM emp.employees
WHERE emp_no IN (
        SELECT emp_no
        FROM `material-1.e mployees.salaries`
        WHERE to_date = '9999-01-01'
        )
GROUP BY year_hired
ORDER BY year_hired;


-------------------------------------------------------------------------------
-- EXERCISE 5:
-- Calculate the average promotion time from Staff to Senior Staff
-------------------------------------------------------------------------------
SELECT avg(extract(day FROM to_date - from_date)) AS avg_promo_time
FROM emp.titles
WHERE title = 'Staff'
    AND to_date != '9999-01-01'
    AND emp_no IN (
        SELECT emp_no
        FROM emp.titles
        WHERE title = "Senior Staff"
        );

--------------------------- Lab finished, good job ----------------------------



-------------------------------------------------------------------------------
---------------------------------- BONUS Qs -----------------------------------
-------------------------------------------------------------------------------

-- NOTE! Use a combination of JOINs and SubQueries to solve the bonus questions!

-------------------------------------------------------------------------------
-- BONUS 1:
-- Retrieve a table of every employees name, the department they are working in
-- and who their manager is.
-- Order by Department
-------------------------------------------------------------------------------
SELECT e.first_name as emp_first_name
    ,e.last_name as emp_last_name
    ,d.dept_name
    ,m.first_name as mngr_first_name
    ,m.last_name as mngr_last_name
FROM emp.departments AS d
INNER JOIN (
    SELECT first_name
        ,last_name
        ,dept_no
    FROM emp.dept_emp
    INNER JOIN emp.employees USING (emp_no)
    WHERE to_date = '9999-01-01'
    ) AS e
    ON e.dept_no = d.dept_no
INNER JOIN (
    SELECT first_name
        ,last_name
        ,dept_no
    FROM emp.dept_manager
    INNER JOIN emp.employees USING (emp_no)
    WHERE to_date = '9999-01-01'
    ) AS m
    ON m.dept_no = d.dept_no
ORDER BY d.dept_name;


-------------------------------------------------------------------------------
-- BONUS 2:
-- Now rewrite the query from EXCERCISE 4 so that it also includes the number 
-- of people hired per year as well. Calculate the fraction of people still 
-- working. Order by year.
-------------------------------------------------------------------------------
SELECT t1.year_hired
    ,still_working
    ,people_hired
    ,still_working / people_hired * 100 AS fraction
FROM (
    SELECT EXTRACT(year FROM hire_date) AS year_hired
        ,COUNT(*) AS still_working
    FROM emp.employees
    WHERE emp_no IN (
            SELECT emp_no
            FROM `material-1.e mployees.salaries`
            WHERE to_date = '9999-01-01'
            )
    GROUP BY year_hired
    ) AS t1
INNER JOIN (
    SELECT EXTRACT(year FROM hire_date) AS year_hired
        ,COUNT(*) AS people_hired
    FROM emp.employees
    GROUP BY year_hired
    ) AS t2
    ON t1.year_hired = t2.year_hired
ORDER BY year_hired;


-------------------------------------------------------------------------------
-- BONUS 3:
-- Who is the current manager of the employees no 54319 and 294238?
-- Include the employees and manager names, dept_no and department name
-------------------------------------------------------------------------------
SELECT te.first_name
    ,te.last_name
    ,te.dept_no
    ,d.dept_name
    ,cm.first_name AS manager_fname
    ,cm.last_name AS manager_lname
FROM (
    SELECT de.dept_no
        ,e.first_name
        ,e.last_name
    FROM emp.employees AS e
    INNER JOIN emp.dept_emp AS de
        ON e.emp_no = de.emp_no
    WHERE e.emp_no IN (54319, 294238)
    ) AS te
INNER JOIN (
    SELECT dm.dept_no
        ,e.first_name
        ,e.last_name
    FROM emp.dept_manager AS dm
    INNER JOIN emp.employees AS e
        ON dm.emp_no = e.emp_no
    WHERE dm.to_date = '9999-01-01'
    ) AS cm
    ON te.dept_no = cm.dept_no
INNER JOIN emp.departments AS d
    ON te.dept_no = d.dept_no;


