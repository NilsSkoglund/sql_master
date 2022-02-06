-------------------------------------------------------------------------------
------------------------- Entity Relations Diagrams ---------------------------
-------------------------------------------------------------------------------
-- Use the Bike Store database for these excercises
-- Strive for solving the problem using code!
-- (not through looking around in the output table)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- How many different stores are there and what are the names of the stores?
-------------------------------------------------------------------------------
SELECT * 
FROM bike_stores.sales_stores;

-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- How many employees are working in each store?
-------------------------------------------------------------------------------

SELECT stores.store_id
    ,COUNT(staff_id)
FROM bike_stores.sales_stores AS stores
INNER JOIN bike_stores.sales_staff AS staff 
    ON stores.store_id = staff.store_id
GROUP BY stores.store_id;

-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- When was the first order made?
-- When was the last order made?
-------------------------------------------------------------------------------
SELECT min(order_date)
    , max(order_date)
FROM bike_stores.orders;


-------------------------------------------------------------------------------
-- EXCERCISE 4:
-- Calculate the total number of orders
-- Correct answer: 1603
-------------------------------------------------------------------------------
SELECT COUNT(*)
FROM bike_stores.orders;


-------------------------------------------------------------------------------
-- EXCERCISE 5:
-- Calculate the number of orders per year
/*
Row	order_count	year
1	635	2016-01-01
2	688	2017-01-01
3	280	2018-01-01
*/
-------------------------------------------------------------------------------
SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, year) as year 
FROM bike_stores.orders
GROUP BY year
ORDER BY year;

-------------------------------------------------------------------------------
-- EXCERCISE 6:
-- Calculate the number of orders for each month in 2018
/*
Row	order_count	month
1	52	2018-01-01
2	35	2018-02-01
3	68	2018-03-01
4	125	2018-04-01
*/
-------------------------------------------------------------------------------
SELECT COUNT(*) as order_count
    , DATE_TRUNC(order_date, month) as month 
FROM bike_stores.orders
WHERE DATE_TRUNC(order_date, year) = "2018-01-01"
GROUP BY month
ORDER BY month;

-------------------------------------------------------------------------------
-- EXCERCISE 7:
-- What was the total revenue of order_id 1?
-- Correct answer ~ 10231.05
-------------------------------------------------------------------------------
SELECT sum(quantity * list_price * (1 - discount))
FROM bike_stores.sales_order_items
WHERE order_id = 1
GROUP BY order_id;


-------------------------------------------------------------------------------
-- EXCERCISE 8:
-- What is the average revenue per order?
-- correct answer ~ 4765
-------------------------------------------------------------------------------
SELECT AVG(order_value) as avg_order_value
FROM 
    (SELECT sum(quantity * list_price * (1 - discount)) as order_value
    , order_id
    FROM bike_stores.order_items
    GROUP BY order_id);

-------------------------------------------------------------------------------
-- EXCERCISE 9:
-- Show the average list price per category (display the category name)
/*
Row	category_name	avg_list_price
1	Children Bicycles	288
2	Comfort Bicycles	682
3	Cruisers Bicycles	730
4	Cyclocross Bicycles	2543
5	Electric Bikes	3282
6	Mountain Bikes	1650
7	Road Bikes	3175
*/
-------------------------------------------------------------------------------

select category_name
    ,avg(list_price) AS avg_list_price
FROM bike_stores.production_categories
INNER JOIN bike_stores.production_products
USING (category_id)
GROUP BY category_name;


-------------------------------------------------------------------------------
-- EXCERCISE 10:
-- Create a table with the top 3 products in terms of quantity sold
-- Correct answer:
    -- 1 | Surly Ice Cream Truck Frameset - 2016 | 167
    -- 2 | Electra Cruiser 1 (24-Inch) - 2016 | 157
    -- 3 | Electra Townie Original 7D EQ - 2016 | 156
-------------------------------------------------------------------------------
SELECT o.product_id
    ,ANY_VALUE(p.product_name) AS name
    ,sum(quantity) AS qty
FROM bike_stores.order_items AS o
JOIN bike_stores.production_products AS p ON o.product_id = p.product_id
GROUP BY product_id
ORDER BY qty DESC;

-------------------------------------------------------------------------------
-- EXCERCISE 11:
-- Create a table with the top 3 products in terms of revenue
/*
Row	product_id	name	tot_product_revenue
1	7	Trek Slash 8 27.5 - 2016	555559
2	9	Trek Conduit+ - 2016	389249
3	4	Trek Fuel EX 8 29 - 2016	368473
*/
-------------------------------------------------------------------------------
SELECT o.product_id
    ,ANY_VALUE(p.product_name) AS name
    ,sum(quantity * o.list_price * (1 - discount)) AS sales
FROM bike_stores.order_items AS o
JOIN bike_stores.production_products AS p ON o.product_id = p.product_id
GROUP BY product_id
ORDER BY sales DESC;


-------------------------------------------------------------------------------
-- EXCERCISE 12:
-- You want to send out a marketing campaign targeted at customers ...
-- ... that has made a purchase in the last month.
-- Get a list of all email addresses for those customers

-- NOTE! Assume that today is the 30th of april in 2018 (2018-04-30)
-- Your query should return 125 rows
-------------------------------------------------------------------------------
SELECT DISTINCT(email) -- Don't need the distinct for the correct answer but good practice
FROM bike_stores.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM bike_stores.orders
    WHERE date_trunc(order_date, month) = "2018-04-01");


-------------------------------------------------------------------------------
-- EXERCISE 14: Answer the questions below with three separate queries
-- 14.1: How many unique customers are there?
    -- 1445
-- 14.2: How many unique customers have made an order in 2018?
    -- 267
-- 14.3: How many new unique customers have made an order in 2018?
    -- 149
-------------------------------------------------------------------------------
-- 14.1
SELECT DISTINCT(customer_id)
FROM bike_stores.orders

-- 14.2
SELECT DISTINCT(customer_id)
FROM bike_stores.orders
WHERE order_date >= "2018-01-01"

-- 14.3
SELECT DISTINCT(customer_id)
FROM bike_stores.orders
WHERE order_date >= "2018-01-01" AND customer_id NOT IN (SELECT DISTINCT(customer_id)
FROM bike_stores.orders
WHERE order_date < "2018-01-01")

-------------------------------------------------------------------------------
-- EXCERCISE 15:
-- Create a list of brand names for all brands ...
-- ... that have 10 or more different products
-------------------------------------------------------------------------------
SELECT count(product_id) AS 
    no_of_products
    ,ANY_VALUE(brand_name) AS brand
FROM bike_stores.production_products
JOIN bike_stores.production_brands USING (brand_id)
GROUP BY brand_id
HAVING no_of_products >= 10;

-------------------------------------------------------------------------------
-- EXERCISE 16:
-- Create a table with the total revenue per brand
-- Which are the top three brands?
-------------------------------------------------------------------------------
SELECT any_value(b.brand_name)
    ,sum(oi.quantity * oi.list_price * (1 - oi.discount)) total_sales
FROM bike_stores.order_items AS oi
JOIN bike_stores.production_products AS p USING (product_id)
JOIN bike_stores.production_brands AS b USING (brand_id)
GROUP BY (b.brand_id)
ORDER BY total_sales DESC;

-------------------------------------------------------------------------------
-- EXCERCISE 17:
-- What is the total revenue for each store in 2018?
/*
Row	store_id	total_revenue	store_name
1	3	169643	Rowlett Bikes
2	1	471683	Santa Cruz Bikes
3	2	1122675	Baldwin Bikes
*/
-------------------------------------------------------------------------------
SELECT so.store_id
    ,ANY_VALUE(s.store_name) AS store_name
    ,CAST(sum(quantity * list_price * (1 - discount)) as INT) AS total_revenue
FROM bike_stores.orders AS so
JOIN bike_stores.order_items AS soi 
    ON so.order_id = soi.order_id
JOIN bike_stores.stores AS s 
    ON so.store_id = s.store_id
GROUP BY store_id;

-------------------------------------------------------------------------------
-------------------------- DATA CLEANING Questions ----------------------------
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

-------------------------------------------------------------------------------
-------------------------- Lab finished, Well done ------------------------------
----------------------------- BONUS QUESTIONS ---------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Bonus 1:
-- Select the customer_id & mail of all customers ...
-- ... who have made 2 or more orders in 2018
-------------------------------------------------------------------------------
SELECT customer_id
    ,email
FROM bike_stores.customers
WHERE customer_id IN (
        SELECT customer_id
        FROM bike_stores.orders
        WHERE EXTRACT(year from order_date) = 2018
        GROUP BY customer_id
        HAVING count(*) > 1
        );


-------------------------------------------------------------------------------
-- Bonus 2:
-- Get the email addresses for every customer that has bought an
-- "Electra Cruiser 1 (24-Inch) - 2016" in the last 12 months
-- (today is 2018-04-30)
-- Your query should return 28 rows
-------------------------------------------------------------------------------
SELECT DISTINCT(email)
FROM bike_stores.order_items as oi
JOIN bike_stores.orders as o USING(order_id)
JOIN bike_stores.customers as c USING(customer_id)
WHERE product_id IN(
    SELECT product_id 
    FROM bike_stores.production_products 
    WHERE product_name = "Electra Cruiser 1 (24-Inch) - 2016")
AND o.order_date > "2017-04-30"

-------------------------------------------------------------------------------
-- Bonus 3:
-- Identify the employee of the month in jan 2018
-- Employee of the month = employee with highest total sum of sales
/*
staff_id	first_name	second_name	tot_sales
6	Marcelene	Boyer	186758
*/
-------------------------------------------------------------------------------

SELECT staff_id
    ,ANY_VALUE(first_name) AS first_name
    ,ANY_VALUE(last_name) AS second_name
    ,sum(quantity * list_price * (1 - discount)) AS tot_sales
FROM bike_stores.order_items AS oi
JOIN bike_stores.orders AS o USING (order_id)
JOIN bike_stores.staff AS s USING (staff_id)
WHERE DATE_TRUNC(order_date, month) = '2018-01-01'
GROUP BY staff_id
ORDER BY tot_sales DESC;

-------------------------------------------------------------------------------
-- Bonus 4:
-- Create a table that shows the change in total revenue on a monthly basis ...
-- ... for the months in 2018. The change should be expressed in percentages
/*
Row	pct_change	month
1	-47	2018-02-01
2	81	2018-03-01
3	125	2018-04-01
*/
-- Note: The revenue went down by 47% in jan-feb, then up 81% in feb-march, ...
-- .. then up 125% in march-april 
-------------------------------------------------------------------------------
SELECT *
    , CAST(((revenue / LAG(revenue) OVER (ORDER BY month)) - 1) * 100 AS INT) as pct_change

FROM (SELECT SUM(revenue) as revenue
    ,DATE_TRUNC(order_date, month) as month
    FROM bike_stores.order_revenue as rev
    JOIN bike_stores.orders as o USING(order_id)
    WHERE DATE_TRUNC(order_date, year) = "2018-01-01"
    GROUP BY month
    ORDER BY month)
ORDER BY month





