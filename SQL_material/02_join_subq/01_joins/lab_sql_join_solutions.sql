-------------------------------------------------------------------------------
------------------------------------- JOINs -----------------------------------
-------------------------------------------------------------------------------
-- EXERCISE 1:
-- Get the name, hire date and date they started the position for all managers
-------------------------------------------------------------------------------
SELECT e.first_name
    ,e.last_name
    ,e.hire_date
    ,dm.from_date
FROM emp.dept_manager AS dm
INNER JOIN emp.employees AS e
    ON dm.emo_no = e.emp_no;

-------------------------------------------------------------------------------
-- EXERCISE 2:
-- get name, gender, birth_date, gender and hire date for all Assistant Engineers
-- 15128 rows
-------------------------------------------------------------------------------
SELECT e.first_name
    ,e.last_name
    ,e.gender
    ,e.birth_date
    ,e.hire_date
FROM emp.employees AS e
INNER JOIN emp.titles AS t
    ON e.emp_no = t.emp_no
WHERE t.title = 'Assistant Engineer';

-------------------------------------------------------------------------------
-- EXERCISE 3:
-- Get the from date, to date, and the job titles of all
-- employees whose first name is “Arie” and have the last name “Staelin”.
-------------------------------------------------------------------------------
SELECT t.from_date
    ,t.to_date
    ,t.title
FROM emp.employees AS e
INNER JOIN emp.titles AS t
    ON e.emp_no = t.emp_no
WHERE e.first_name = 'Arie'
    AND e.last_name = 'Staelin';

-------------------------------------------------------------------------------
-- EXERCISE 4:
-- How many male and how many female managers do we have in the company?
-------------------------------------------------------------------------------
SELECT e.gender
    ,count(*) AS num_managers
FROM emp.dept_manager AS dm
INNER JOIN emp.employees AS e
    ON dm.emp_no = e.emp_no
GROUP BY e.gender;

-------------------------------------------------------------------------------
-- EXCERCISE 5:
-- Calculate the average salary by gender for all employees
-------------------------------------------------------------------------------
SELECT e.gender
    ,AVG(s.salary) AS avg_salary
FROM emp.employees AS s
INNER JOIN emp.salaries AS e
    ON e.emp_no = s.emp_no;

GROUP BY e.gender;


-------------------------------------------------------------------------------
-- EXCERCISE 6:
-- Get the highest salary by department. Order from high to low.
-------------------------------------------------------------------------------
SELECT de.dept_no
    ,MAX(s.salary) AS highest_salary
FROM emp.dept_emp AS de
INNER JOIN emp.salaries AS s
    ON de.emp_no = s.emp_no
GROUP BY de.dept_no
ORDER BY highest_salary DESC;

--------------------------- Lab finished, good job ----------------------------



-------------------------------------------------------------------------------
---------------------------------- BONUS Qs -----------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- BONUS 1:
-- We want to get the average management salary per department from high to low
-- (and we want the name of the department)
-------------------------------------------------------------------------------
SELECT d.dept_name AS department_name
    ,AVG(s.salary) AS avg_management_salary
FROM emp.dept_manager AS dm
INNER JOIN emp.departments AS d
    ON dm.dept_no = d.dept_no
INNER JOIN emp.salaries AS s
    ON dm.emp_no = s.emp_no
GROUP BY dm.dept_no, d.dept_name
ORDER BY avg_management_salary DESC;


-------------------------------------------------------------------------------
-- BONUS 2:
-- Which three departments have the highest average salary?
-- Specifications:
    -- Only include employees who are currently working. 
        -- (where dept_emp.to_date = '9999-01-01')
    -- and only count their current salary 
        -- (where salary.to_date = '9999-01-01')
-------------------------------------------------------------------------------
SELECT AVG(s.salary) AS avg_salary
    ,de.dept_no
    ,ANY_VALUE(d.dept_name) AS dept_name
FROM emp.dept_emp AS de
JOIN emp.departments AS d ON de.dept_no = d.dept_no
JOIN emp.salaries AS s ON s.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01'
    AND s.to_date = '9999-01-01'
GROUP BY de.dept_no
ORDER BY avg_salary DESC;


-------------------------------------------------------------------------------
-- BONUS 3:
-- This questions builds on the previous question. 
-- Add in gender, so you have the following two questions: 
-- Which three departments have the highest paying salaries for men?
-- Which three departments have the highest paying salaries for women?
-------------------------------------------------------------------------------
SELECT de.dept_no
    ,ANY_VALUE(dept_name) as dept_name
    ,e.gender
    ,AVG(s.salary) AS avg_salary
FROM emp.dept_emp AS de
INNER JOIN emp.departments as d
    ON de.dept_no = d.dept_no
INNER JOIN emp.salaries AS s
    ON de.emp_no = s.emp_no
INNER JOIN emp.employees AS e
    ON de.emp_no = e.emp_no
WHERE de.to_date = '9999-01-01'
    AND s.to_date = '9999-01-01'
GROUP BY de.dept_no, e.gender
ORDER BY e.gender, avg_salary;


-------------------------------------------------------------------------------
-- BONUS 4:
-- What is the Average Salary for senior engineers after 5 years in that role?
    -- Assume you are making this calculation in 2002
    -- meaning that we are interested in senior engineers hired in 1997 
-------------------------------------------------------------------------------
SELECT AVG(salary)
FROM emp.titles as t
JOIN emp.salaries as s
    ON t.emp_no = s.emp_no
WHERE t.title = "Senior Engineer"
    AND t.to_date = "9999-01-01"
    AND EXTRACT(year FROM t.from_date) = 1997
    AND s.to_date = "9999-01-01";
