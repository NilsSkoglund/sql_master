-------------------------------------------------------------------------------
-------------------------------- Data Cleaning --------------------------------
-------------------------------------------------------------------------------
-- Use the Bike Store database for these excercises
-- Always strive for solving the problem using code!
-- (not through looking around in the output table)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- Who is the manager of Kali Vargas (staff_id = 8)
-------------------------------------------------------------------------------
SELECT *
FROM bike_stores.sales_staff as s1
    JOIN bike_stores.sales_staff as s2
        ON CAST(s1.manager_id as INT) = s2.staff_id -- CAST! manager_id = String but staff_id = Int
WHERE s1.staff_id = 8;


-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- What percentage of time is the delivery on time?
-- Definition of deliviery on time: 
    -- shipped date <= required date
-------------------------------------------------------------------------------
-- step 1: WHERE shipped date is not null
SELECT COUNT(*)
FROM bike_stores.orders
WHERE shipped_date IS NOT NULL

-- step 2: WHERE shipped date <= required date
    -- Note! shipped_date is stored as a string
        -- Therefore we use the CAST() functions
            -- So the DATE_DIFF()
SELECT 
    COUNT(*) 
FROM bike_stores.orders
WHERE shipped_date IS NOT NULL 
    AND DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) <= 0;
    
-- step 3: Combine step 1 & 2
    -- use step 1 as a subquery in step 2 (in the select statement)

SELECT 
    COUNT(*) 
    /
    (-- Insert step 1 here)
FROM bike_stores.orders
WHERE shipped_date IS NOT NULL 
    AND DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) <= 0;

-- Final code
SELECT COUNT(*) / (
        SELECT COUNT(*)
        FROM bike_stores.orders
        WHERE shipped_date IS NOT NULL
        )
FROM bike_stores.orders
WHERE shipped_date IS NOT NULL
    AND DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) <= 0;    
        
        
-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- What is the average delay when the delivery is not on time?
-------------------------------------------------------------------------------
-- Step 1: create list of difference between shipped_date and req date
           -- (where there is a delay)
SELECT DATE_DIFF(CAST(
            shipped_date AS DATE), required_date, DAY) AS diff
FROM bike_stores.orders
WHERE shipped_date IS NOT NULL
    AND DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) > 0;
        
-- Step 2: Use step 1 as a subquery in the FROM statement
SELECT AVG(diff) as avg_diff
FROM () -- insert step 1 in the parentheses
        ;

-- Final code
SELECT AVG(diff) AS avg_diff
FROM (
    SELECT DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) AS diff
    FROM bike_stores.orders
    WHERE shipped_date IS NOT NULL
        AND DATE_DIFF(CAST(shipped_date AS DATE), required_date, DAY) > 0
    )
    ;

        
        
        
-- Identify products with highest delay(?)
    -- If more than 10 has been sold or some condition like that

