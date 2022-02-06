------------------------------- NOTE! to teacher ------------------------------
-- Before you start this codealong, do a short theory session
-- Using the SubQs slides in Google Drive
-------------------------------------------------------------------------------


----------------- Ok, let's introduce SubQueries in code!----------------------
---------- First we will look at SubQueries in the WHERE statement-------------


-- Query 1: All information from the "employeees" table
SELECT *
FROM emp.employees

-- Query 2: All employee numbers for Assistant Engineers
SELECT emp_no
FROM emp.titles
WHERE title = 'Assistant Engineer'

-- Query 3: All information from the employeees table (Query 1) ...
-- ... but only for the Assistant Engineers (Query 2)

SELECT *
FROM emp.employees -- Query 1
WHERE emp_no IN -- Add in WHERE statement
        (
         -- Insert Query 2 
        )


SELECT *
FROM emp.employees -- Query 1
WHERE emp_no IN (
        SELECT emp_no -- Query 2 (The SubQuery)
        FROM emp.titles
        WHERE title = 'Assistant Engineer'
)

------------------------- Open up the theory slides! --------------------------
--------------- Go through Order of Execution with SubQueries -----------------
-------------------------------------------------------------------------------

------------ Stop and make sure that everyone is following along --------------
--------------- You can really take your time here, no stress -----------------


-------------------------------------------------------------------------------
-- More examples of SubQueries inside WHERE
    -- We filter in the WHERE clause and can use SubQueries ...
    -- to create conditions we want to filter on
-------------------------------------------------------------------------------

-- Let's get all information from the employees table
    -- about each of the current department managers

-- Start with the SubQuery
    -- Getting the employee number of all current department managers
SELECT emp_no
FROM emp.dept_manager
WHERE to_date = '9999-01-01';

-- Outer Query
SELECT * 
FROM emp.employees 
WHERE emp_no IN
        (
         -- Copy & Paste SubQuery inside here
        );


-- Let's get info about all employees with a salary above 100000
SELECT *
FROM emp.employees AS e
WHERE e.emp_no IN (
        SELECT s.emp_no
        FROM emp.salaries AS s
        WHERE s.salary > 100000
        );

    
-- Info about all salaries that are above the average Salary
FROM emp.salaries
WHERE salary > (
        SELECT AVG(salary)
        FROM emp.salaries
        );


----------------------- Next up, nested SubQueries ----------------------------

---------------------------- Mini Challenge -----------------------------------
-- Get all info from the employees table ...
    -- ... for employees with an above average salary
    -- To solve this you should use a nested SubQuery
    -- Should return 60453 rows
-------------------------------------------------------------------------------

-- Step by Step solution to Mini Challenge

-- Step 1, nested SubQuery
SELECT AVG(salary)
FROM emp.salaries

-- Step 2, SubQuery
SELECT emp_no
FROM emp.salaries 
WHERE salary > (
               -- Insert nested SubQuery
               )
               
-- Step 3, Outer Query
SELECT *
FROM emp.employees 
WHERE emp_no IN (
               -- Insert SubQuery (containing the nested SubQuery)
                )

-- Step 1-3 combined ...

SELECT *
FROM emp.employees 
WHERE emp_no IN (
        SELECT emp_no
        FROM emp.salaries 
        WHERE salary > (
                SELECT AVG(salary)
                FROM emp.salaries
                )
        );

-------------------------------------------------------------------------------
------------------------- Open up the theory slides! --------------------------
------------ Go through Order of Execution with Nested SubQueries -------------
------------ The example in the slides is from the Mini Challenge -------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- SubQueries inside FROM
-- We can use SubQueries inside the FROM statement
-------------------------------------------------------------------------------


-- One situation where this is useful is if we want to create a new column
    -- and then do calculations on the new column

-- For example: Let's say we want quarterly data ...
    -- number of new employees 

-- Let's look at the data
SELECT * 
FROM emp.employees;

-- Step 1: Create a new column with hire_date as quarterly data
SELECT *
    ,DATE_TRUNC(hire_date, quarter) as quarter
FROM emp.employees;

-- Then we can easily do our calucations
SELECT quarter
    , COUNT(quarter) as new_employees
FROM(
-- Insert step 1
)
GROUP BY quarter
ORDER BY quarter;


-- Final Query
SELECT quarter
    ,COUNT(quarter) AS new_employees
FROM (
    SELECT *
        ,DATE_TRUNC(hire_date, quarter) AS quarter
    FROM emp.employees
    )
GROUP BY quarter
ORDER BY quarter;

-------------------------------------------------------------------------------
------------------------- Open up the theory slides! --------------------------
------------ Start with the SubQuery in the FROM satement slides --------------
-- Then do the summary slides of what we have covered in this SubQ codealong --
-------------------------------- THE END --------------------------------------
-------------------------------------------------------------------------------

