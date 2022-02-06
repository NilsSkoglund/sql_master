-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- RANK the products based on the list price using the RANK() function 
-- Rank them from high to low and sort by rank
-- Only select the product_id, list_price & rank column

/*
product_id	list_price	rank_high_to_low
155	11999.99	1
149	7499.99	2
156	6499.99	3
*/
-------------------------------------------------------------------------------
SELECT product_id
    , list_price
    , RANK() OVER (ORDER BY list_price DESC) as rank_high_to_low
FROM bike_stores.production_products
ORDER BY rank_high_to_low

-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- Change the rank to low to high

/*
product_id	list_price	rank_low_to_high
263	89.99	1
84	109.99	2
86	149.99	3
*/
-------------------------------------------------------------------------------
SELECT product_id
    , list_price
    , RANK() OVER (ORDER BY list_price) as rank_low_to_high
FROM bike_stores.production_products
ORDER BY rank_low_to_high

-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- You are given an incomplete query below. Add the brand_avg_price column

/*
category_name	brand_id	list_price	brand_avg_price
Cyclocross Bicycles	8	1549	1581.9975
Cyclocross Bicycles	8	1680.99	1581.9975
Cyclocross Bicycles	8	1549	1581.9975
Cyclocross Bicycles	8	1549	1581.9975
Cyclocross Bicycles	9	3499.99	3183.323333
Cyclocross Bicycles	9	3499.99	3183.323333
Cyclocross Bicycles	9	3299.99	3183.323333
Cyclocross Bicycles	9	3999.99	3183.323333
Cyclocross Bicycles	9	1799.99	3183.323333
Cyclocross Bicycles	9	2999.99	3183.323333
*/
-------------------------------------------------------------------------------
SELECT c.category_name  
    , p.brand_id
    , list_price
    , AVG(list_price)
        OVER (partition by brand_id) as brand_avg_price
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id
WHERE c.category_id = 4;


-------------------------------------------------------------------------------
-------------------------- Lab finished, Well done ----------------------------
----------------------------- BONUS QUESTIONS ---------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- BONUS 1:
-- You are given an incomplete query below. Add a cumulative sum column

/*
order_count	month	order_count_cumulative_sum
50	2017-01-01	50
57	2017-02-01	107
67	2017-03-01	174
57	2017-04-01	231
57	2017-05-01	288
63	2017-06-01	351
52	2017-07-01	403
65	2017-08-01	468
53	2017-09-01	521
65	2017-10-01	586
55	2017-11-01	641
47	2017-12-01	688
*/
-------------------------------------------------------------------------------
SELECT * 
    ,SUM(order_count)
    OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS order_count_cumulative_sum
FROM (
    SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, month) as month 
    FROM bike_stores.orders
    WHERE DATE_TRUNC(order_date, year) = "2017-01-01"
    GROUP BY month
    ORDER BY month
)


-------------------------------------------------------------------------------
-- BONUS 2:
-- You are given an incomplete query below. Add a pct_change column

/*
order_count	month	pct_change
50	2017-01-01	null
57	2017-02-01	14
67	2017-03-01	18
57	2017-04-01	-15
57	2017-05-01	0
63	2017-06-01	11
52	2017-07-01	-17
65	2017-08-01	25
53	2017-09-01	-18
65	2017-10-01	23
55	2017-11-01	-15
47	2017-12-01	-15
*/
-------------------------------------------------------------------------------

SELECT order_count
    , month
    , CAST((monthly_change - 1) * 100 AS INT) as pct_change

FROM (
    
    SELECT *
        , order_count / LAG(order_count) 
        OVER (
            ORDER BY month
            ) AS monthly_change

    FROM (
        SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, month) as month 
        FROM bike_stores.orders
        WHERE DATE_TRUNC(order_date, year) = "2017-01-01"
        GROUP BY month
        ORDER BY month
        )
    ORDER BY month
        )
        
-------------------------------------------------------------------------------
-- BONUS 3:
-- You are given an incomplete query below. Add a 7 day moving_avg column

/*
order_count	day	moving_avg
3	2018-01-01	3
2	2018-01-02	2.5
2	2018-01-04	2.333333333
1	2018-01-05	2
2	2018-01-06	2
2	2018-01-07	2
2	2018-01-09	2
1	2018-01-10	1.875
1	2018-01-11	1.625
*/
-------------------------------------------------------------------------------

-- Moving average of daily orders in 2018
SELECT *
    , AVG(order_count)
    OVER (
        ORDER BY day
        ROWS BETWEEN 7 PRECEDING AND 0 FOLLOWING -- Can play around with this window
    ) as moving_avg
FROM (
    SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, day) as day 
    FROM bike_stores.orders
    WHERE DATE_TRUNC(order_date, year) = "2018-01-01"
    GROUP BY day
    ORDER BY day
    )
ORDER BY day
;