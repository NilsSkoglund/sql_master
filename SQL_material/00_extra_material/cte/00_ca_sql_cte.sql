-------------------------------------------------------------------------------
-- Introducing CTEs (Common Table Expression)
-- Having multiple JOINs in one querry can quickly become confusing
-- This is where CTEs are very useful. They help us structure the problem
-- and break it down into smaller solvable parts
-- Often they are required for more complex and interesting querries
-------------------------------------------------------------------------------
-- CTE structure
WITH my_cte
AS (
    SELECT emp_no
    FROM employees.salaries
    WHERE salaries > 100000
)
SELECT *
FROM my_cte


-- often CTEs are nessecary.
-- Lets say we want to get the fraction of all employees that ever worked at
-- the company and still receive a salary. OBS! LEFT JOIN in da house.
-- This won't work. Aggregations of aggregations not allowed.
-- Also the WHERE statement won't do what we want because it filters after
-- the JOIN
SELECT COUNT(e.emp_no) AS emps
    ,COUNT(ANY_VALUE(s.salary)) AS emps_w_sal
    ,emps_w_sal / emps AS fraction_receiving_sal
FROM employees.employees AS e
LEFT JOIN employees.salaries AS s
    ON e.emp_no = s.emp_no
WHERE s.to_date = '9999-01-01'
GROUP BY e.emp_no;


-- We can solve this by using multiple CTEs
WITH current_salaries
AS (
    SELECT emp_no
        ,salary
    FROM employees.salaries
    WHERE to_date = '9999-01-01'
    )
    ,emps_with_any_sal
AS (
    SELECT e.emp_no
        ,ANY_VALUE(s.salary) AS any_sal
    FROM employees.employees AS e
    LEFT JOIN current_salaries AS s
        ON e.emp_no = s.emp_no
    GROUP BY e.emp_no
    )
SELECT COUNT(emp_no) AS emps
    ,COUNT(any_sal) AS emps_w_current_sal
    ,COUNT(any_sal) / COUNT(emp_no) AS fraction_emps_w_sal
FROM emps_with_any_sal;


-- CLEANING UP SALARIES!
-- Using CTE & JOIN to select all the "latests" salaries
WITH latest_salaries
AS (
    SELECT emp_no
        ,max(from_date) AS latest_from_date
    FROM employees.salaries
    GROUP BY emp_no
    )
SELECT gender
    ,avg(salary)
FROM employees.latest_salaries AS ls
INNER JOIN employees.employees AS e
    ON ls.emp_no = e.emp_no
GROUP BY gender;