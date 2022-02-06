
-- When we start writing queries that has more than just some basic logic in them
-- CTEs can make our life life easier. 
-- CTEs enable us to break down our queries ...
-- ... into multiple components
-- often making our problem easier to solve!

-------------------------------------------------------------------------------
-- One such example is when using Date Functioncs together with GROUP BY

-- Date functions are often useful together with GROUP BY
-- When doing this your code can quickly become confusing
-------------------------------------------------------------------------------

-- We want to calculate the number of people that were hired per year
-- Without using a CTE:
SELECT extract(year FROM hire_date) AS year_hired
    ,count(extract(year FROM hire_date)) AS no_of_hires
FROM emp.employees
GROUP BY extract(year FROM hire_date);



-- CTEs to the rescue!
-- We break it down!

-- Step 1 -- Extract the date
-- Create a new table with the "extracted" date
SELECT 
    extract(year FROM hire_date) as year_hired
FROM emp.employees


-------------------------------------------------------------------------------
-- CTEs!

WITH temp_table AS
(
    -- Insert query 
)
SELECT * 
FROM temp_table;
-------------------------------------------------------------------------------


-- Step 2 -- Perform aggregate calculations on the extracted date
-- With the help of CTE syntax!

WITH temp_table AS
(
-- Step 1 
SELECT 
    extract(year FROM hire_date) as year_hired
FROM emp.employees
)
-- Step 2 
SELECT year_hired
    ,count(year_hired) as no_of
FROM temp_table
GROUP BY year_hired
ORDER BY year_hired;

-- Our code is a few lines longer, but more digestable
