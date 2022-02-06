-- Remember the data from yesterday
SELECT * 
FROM data_cleaning.stock_unclean;

-- With missing values especially in december
SELECT * 
FROM data_cleaning.stock_unclean
ORDER BY stocking_date;

-- Let's say we want to calculate the sum of stocked quantity

-- When we did it yesterday we got ~ 8000 when we "ignored" NULL values

-- We got ~ 10 700 when we "imputed" the mean value 

-- Now we are going to use a technique to get a better estimate

-- Because this technique will let us capture the time dimension in the date

-- We can see in the data that it is a strong growth trend of the quantity
SELECT * 
FROM data_cleaning.stock_unclean
ORDER BY stocking_date;

-- It is likely that filling in missing values in december with the mean value
    -- Will heavily underestimate the actual values


-- Introducing window functions
-- Window functions enable us to capture the time dimension in our data

-- In this case we will use it together with COALESCE

-- We will impute the missing values with the "latest seen" value in that column
    -- A technique called "forward filling"

SELECT *
    , COALESCE(stocked_quantity, 
        LAST_VALUE(stocked_quantity IGNORE NULLS) 
        OVER (
            ORDER BY stocking_date
            )
            ) as stocked_qty
FROM data_cleaning.stock_unclean
ORDER BY stocking_date;

-- Then calculate the sum
SELECT sum(stocked_qty) as sum_stocked_qty
FROM
    (
    -- Insert query
    );

-- We got ~ 12 300 when we "imputed" using "forward filling" 
    -- with the help of "window function" syntax

-- This estimate of 12 300 is definitely a better approximation of reality


