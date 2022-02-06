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



-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- How many employees are working in each store?
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- When was the first order made?
-- When was the last order made?
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 4:
-- Calculate the total number of orders
-- Correct answer: 1603
-------------------------------------------------------------------------------



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



-------------------------------------------------------------------------------
-- EXCERCISE 7:
-- What was the total revenue of order_id 1?
-- Correct answer ~ 10231.05
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 8:
-- What is the average revenue per order?
-- correct answer ~ 4765
-------------------------------------------------------------------------------



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



-------------------------------------------------------------------------------
-- EXCERCISE 10:
-- Create a table with the top 3 products in terms of quantity sold
-- Correct answer:
    -- 1 | Surly Ice Cream Truck Frameset - 2016 | 167
    -- 2 | Electra Cruiser 1 (24-Inch) - 2016 | 157
    -- 3 | Electra Townie Original 7D EQ - 2016 | 156
-------------------------------------------------------------------------------



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



-------------------------------------------------------------------------------
-- EXCERCISE 12:
-- You want to send out a marketing campaign targeted at customers ...
-- ... that has made a purchase in the last month.
-- Get a list of all email addresses for those customers

-- NOTE! Assume that today is the 30th of april in 2018 (2018-04-30)
-- Your query should return 125 rows
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXERCISE 14: Answer the questions below with three separate queries
-- 14.1: How many unique customers are there?
    -- 1445
-- 14.2: How many unique customers have made an order in 2018?
    -- 267
-- 14.3: How many new unique customers have made an order in 2018?
    -- 149
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 15:
-- Create a list of brand names for all brands ...
-- ... that have 10 or more different products
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXERCISE 16:
-- Create a table with the total revenue per brand
-- Which are the top three brands?
-------------------------------------------------------------------------------



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



-------------------------------------------------------------------------------
-------------------------- DATA CLEANING Questions ----------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- EXCERCISE 1:
-- Who is the manager of Kali Vargas (staff_id = 8)
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- What percentage of time is the delivery on time?
-- Definition of deliviery on time: 
    -- shipped date <= required date
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- What is the average delay when the delivery is not on time?
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-------------------------- Lab finished, Well done ------------------------------
----------------------------- BONUS QUESTIONS ---------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Bonus 1:
-- Select the customer_id & mail of all customers ...
-- ... who have made 2 or more orders in 2018
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Bonus 2:
-- Get the email addresses for every customer that has bought an
-- "Electra Cruiser 1 (24-Inch) - 2016" in the last 12 months
-- (today is 2018-04-30)
-- Your query should return 28 rows
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Bonus 3:
-- Identify the employee of the month in jan 2018
-- Employee of the month = employee with highest total sum of sales
/*
staff_id	first_name	second_name	tot_sales
6	Marcelene	Boyer	186758
*/
-------------------------------------------------------------------------------



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



