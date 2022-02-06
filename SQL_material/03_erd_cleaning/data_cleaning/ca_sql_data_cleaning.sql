-------------------------------------------------------------------------------
-------------------------------- Data Cleaning --------------------------------
-- Use the stock_unclean table in the data_cleaning database for this codealong
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--------------------------------- NULL VALUES ---------------------------------
-------------------------------------------------------------------------------

---------------------------------- Exploring ----------------------------------


SELECT * 
FROM data_cleaning.stock_unclean;

SELECT * 
FROM data_cleaning.stock_unclean
ORDER by stocking_date;
-- All data is missing from 2021-12-01
    -- Maybe this needs to be looked into?

-- Given that we only have 35 rows in total ...
-- it is easy to explore the data just by looking at the table

-- Now if we have more data we need other ways of exploring the missing data
-- Below we'll "explore" the missing data with help of code

-- Filtering so were only seeing the rows there stocked_quantity is NULL
SELECT * 
FROM data_cleaning.stock_unclean
WHERE stocked_quantity IS NULL;

-- Count NULL values per stocking date
SELECT stocking_date
    , COUNT(*) as data_missing
FROM data_cleaning.stock_unclean
WHERE stocked_quantity IS NULL
GROUP BY stocking_date;


-- Count percent of values missing in the stocked_quantity column 
SELECT 
    COUNT(*)
    /
    (SELECT COUNT(*)
    FROM data_cleaning.stock_unclean) AS pct_null
FROM data_cleaning.stock_unclean
WHERE stocked_quantity IS NULL;


---------------------------------- Ignoring -----------------------------------

-- Let's say we wan't to caluclate the sum of the stocked quantity column

-- One way of doing it
SELECT SUM(stocked_quantity) as total_stocked_quantity
FROM data_cleaning.stock_unclean;
-- The null values will just be ignored
-- Returns 7976

---------------------------------- Imputing ------------------------------------
-- "filling in the gaps"
-- using COALESCE

SELECT *
FROM data_cleaning.stock_unclean;

-- filling in the gaps in stocked quantity with 100
SELECT *
    , COALESCE(stocked_quantity, 100) as stocked_quantity_filled_100 -- When stocked_quantity is NULL, put 100 as the value
FROM data_cleaning.stock_unclean;

-- filling in the gaps in stocked quantity with the average value
SELECT *
    , COALESCE(stocked_quantity, 100) as stocked_quantity_filled_100 -- When stocked_quantity is NULL, put 100 as the value
    , COALESCE(stocked_quantity, 
            (SELECT avg(stocked_quantity) FROM data_cleaning.stock_unclean)
            ) AS stocked_quantity_filled_mean -- When stocked quantity is NULL, put the average as the value
FROM data_cleaning.stock_unclean;


-- Copy & paste + remove * and first COALESCE
SELECT COALESCE(stocked_quantity, 
            (SELECT avg(stocked_quantity) FROM data_cleaning.stock_unclean)
            ) AS stocked_quantity_filled_mean 
FROM data_cleaning.stock_unclean;

-- Add in SUM()
-- change col name to total_stocked_quantity

-- We get ~ 10737 as our estimation

-- Back to slides!

-------------------------------------------------------------------------------
----------------------------- END of NULL VALUES ------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------------------------------- Type Conversion -------------------------------
-------------------------------------------------------------------------------

-- Let's say we wan't to calculate the total amount spent on our meal stock

-- So we want to take the sum of stocked_quantity * price


SELECT *
FROM data_cleaning.stock_unclean;

SELECT SUM(stocked_quantity*price)
FROM data_cleaning.stock_unclean;

-- pull up overview of table
-- show that price is of STRING data type

SELECT sum(stocked_quantity * CAST(price AS INTEGER))
FROM data_cleaning.stock_unclean;

-- Now it works!

-- Back to slides!

-------------------------------------------------------------------------------
------------------------------ END of Codealong -------------------------------
-------------------------------------------------------------------------------