-------------------------------------------------------------------------------
-------------------------------------- CASE -----------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- Create new categories for the titles. Categorize them as Engineers, Staff
-- and Managers. Retrieve a table where these new categories are connected to
-- the emp_no.
-------------------------------------------------------------------------------
SELECT emp_no
    ,CASE 
        WHEN title IN ("Engineer", "Senior Engineer", "Assistant Engineer"
                )
            THEN "Engineer"
        WHEN title IN ("Staff", "Senior Staff")
            THEN "Staff"
        ELSE "Managers"
        END AS title_cat
FROM emp.titles;

-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- Now modify the query from above so that you count the number of active
-- employees in each category that you created.
-------------------------------------------------------------------------------
SELECT count(*) as staff_count
    ,CASE 
        WHEN title IN ("Engineer", "Senior Engineer", "Assistant Engineer"
                )
            THEN "Engineer"
        WHEN title IN ("Staff", "Senior Staff")
            THEN "Staff"
        ELSE "Managers"
        END AS title_cat
FROM emp.titles
group by title_cat;


-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- Create a new category for different levels of salary.
-- Medium: 20000 +- of the average salary
-- Low: below Medium, High: above medium
-------------------------------------------------------------------------------
SELECT emp_no
    ,salary
    ,CASE 
        WHEN salary < (
                SELECT avg(salary)
                FROM emp.salaries
                ) - 20000
            THEN 'Low'
        WHEN salary > (
                SELECT avg(salary)
                FROM emp.salaries
                ) + 20000
            THEN 'High'
        ELSE 'Medium'
        END AS sal_cat
FROM emp.salaries;


-------------------------------------------------------------------------------
-- EXCERCISE 4:
-- Modify above query so that you count the number of employees and managers
-- in each category. Do this only for the currently employed
-------------------------------------------------------------------------------
SELECT CASE 
        WHEN emp_no IN (
                SELECT emp_no
                FROM emp.titles
                WHERE title = 'Manager'
                )
            THEN 'Manager'
        ELSE 'Employee'
        END AS emp_cat
    ,CASE 
        WHEN salary < (
                SELECT avg(salary)
                FROM emp.salaries
                ) - 20000
            THEN 'Low'
        WHEN salary > (
                SELECT avg(salary)
                FROM emp.salaries
                ) + 20000
            THEN 'High'
        ELSE 'Medium'
        END AS sal_cat
    ,count(*) AS counts
FROM emp.salaries
WHERE to_date = '9999-01-01'
GROUP BY emp_cat
    ,sal_cat;