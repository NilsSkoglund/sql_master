-------------------------------------------------------------------------------
---------------------------- Window Functions ---------------------------------
-------------------------------------------------------------------------------


-- https://cloud.google.com/bigquery/docs/reference/standard-sql/analytic-function-concepts

/*
An analytic function computes values over a group of rows ...
    ... and returns a single result for each row.

With analytic functions you can compute 
    - moving averages, 
    - rank items, 
    - calculate cumulative sums, 
    - and lots more ...
*/

-------------------------------------------------------------------------------

/*
An analytic function includes an OVER clause ...
    ... which defines a window of rows around the row being evaluated

For each row, the analytic function result ...
    ... is computed using the selected window of rows as input
*/

-- Coding time.

-------------------------------------------------------------------------------
------------------------------- Core Syntax -----------------------------------
-------------------------------------------------------------------------------

-- Core syntax in Window functions
    -- OVER() (always!)
    -- Partition by
    -- order by

-- OVER()
SELECT *
    , AVG(meal_price) 
    OVER () as avg_meal_price
FROM data_cleaning.meals 

-- OVER (PARTITION BY ...)
SELECT *
    , AVG(meal_price) 
    OVER (
        PARTITION BY eatery) as avg_price_eatery
FROM data_cleaning.meals

-- RANK() + OVER (ORDER BY)
SELECT * 
    , RANK() OVER (
        ORDER BY meal_price) as meal_rank
FROM data_cleaning.meals

-- RANK() + OVER (PARTITION BY ORDER BY)
SELECT *
    , RANK() OVER(
        PARTITION BY eatery 
        ORDER BY meal_price) as meal_rank_per_eatery
FROM data_cleaning.meals

-- Summary
SELECT *
    , AVG(meal_price) OVER () as avg_price
    , AVG(meal_price) OVER (PARTITION BY eatery) as avg_price_eatery
    , RANK() OVER (ORDER BY meal_price) as meal_rank
    , RANK() OVER(PARTITION BY eatery ORDER BY meal_price) as meal_rank_eatery
FROM data_cleaning.meals 

-------------------------------------------------------------------------------
------------------------------- First Example ---------------------------------
------------------------------ Moving Average ---------------------------------
-------------------------------------------------------------------------------
/* AVG() 
    OVER (
        ORDER BY date
        ROWS BETWEEN x PRECEDING AND x FOLLOWING
        )
*/

-- favo data, orders table
SELECT * 
FROM data_cleaning.orders

-- Counting no. of orders per day
SELECT COUNT(*) as order_count
    , order_date
FROM data_cleaning.orders
GROUP BY order_date
ORDER BY order_date;

-- Moving average of daily orders
SELECT *
    , AVG(order_count)
    OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 0 FOLLOWING -- Can play around with this window
    )
FROM (
    -- Insert query from above here
    )
ORDER BY order_date
;

-- Final query
SELECT *
    , AVG(order_count)
    OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 0 FOLLOWING
    )
FROM (
    SELECT COUNT(*) as order_count
        , order_date
    FROM data_cleaning.orders
    GROUP BY order_date
    ORDER BY order_date
    )
ORDER BY order_date
;

-------------------------------------------------------------------------------
-------------------------- First example finished -----------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
------------------------------- Second Example --------------------------------
------------------------------ Cumulative Sum ---------------------------------
-------------------------------------------------------------------------------
/* SUM() 
    OVER (
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
*/

-- Step 1, order_count per month
SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, month) as year_month
FROM data_cleaning.orders
GROUP BY year_month
ORDER BY year_month;


SELECT * 
FROM (
    -- insert query
)

SELECT * 
    ,SUM(order_count)
    OVER (
        ORDER BY year_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS order_count_cumulative_sum
FROM (
    -- insert query
)

-- final query
SELECT * 
    ,SUM(order_count)
    OVER (
        ORDER BY year_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS order_count_cumulative_sum
FROM (
    SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, month) as year_month
    FROM data_cleaning.orders
    GROUP BY year_month
    ORDER BY year_month
)
-------------------------------------------------------------------------------
-------------------------- Second example finished ----------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------------------------------ Third example ---------------------------------
-------------------------------- Growth Rate ----------------------------------
-------------------------------------------------------------------------------

-- We will be using the LAG() function

-- monthly growth rate of order_count

-- Step 1, order_count per month (copy + paste from previous query)
SELECT COUNT(*) order_count
    , DATE_TRUNC(order_date, month) as  month
FROM data_cleaning.orders
GROUP BY month 

-- Put it as a subquery in the FROM statement
SELECT *
FROM (
    -- Insert query
    )

-- LAG()
SELECT *
    ,LAG(order_count) OVER (
        ORDER BY month
        ) AS order_count_lagging_month
FROM (
    -- Insert query 
    )
ORDER BY month


-- order_count / order_count_lagging_month
SELECT *
    , order_count / LAG(order_count) 
    OVER (
        ORDER BY month
        ) AS monthly_change

FROM (
    -- Insert query
    )
ORDER BY month

-- Making it look nicer
    -- Getting the result table with percent change with integers
SELECT month
    , CAST((monthly_change - 1) * 100 AS INT) as pct_change
FROM (
    -- Insert query
    )

-------------------------------------------------------------------------------
--------------------------- Third example finished ----------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
----------------------------- Codealong finished ------------------------------
-------------------------------------------------------------------------------