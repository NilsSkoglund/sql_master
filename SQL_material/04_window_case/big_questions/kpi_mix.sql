-------------------------------------------------------------------------------
-------------------------------- Food Delivery --------------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Calculate the Average Revenue Per User
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Calculate number of registrations per month
-- Then calculate the cumulative sum of regististrations per month
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
/* 
Assign the users into 3 different categories:
    1. Users generating less than 150 in revenue = “low rev users”
    2. Users who have generated between 150 and 300 in revenue = “mid rev users”
    3. Users generating more than 300 in revenue = “high rev users”
 
Your query should return the frequency count for each category
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Calculate the Growth Rate of Monthly Active Users

/* 
A user is defined as a monthly active user ... 
... if he/she has made at least one order during the given month
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Calculate profit per eatery

-- You might want to look into CTEs to for this question

/*
Instructions for calculating profit:
    1. Revenue = sum(meal_price * order_quantity)
    2. Cost = sum(meal_cost * stocked_quantity)
    3. Profit = Revenue - Cost
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Each month there is a contest for the meals that have generated the most profit
/* 
Write a query that returns the top five ranked meals ...
    ... in terms of monthly generated profit. 

For this question, the profit for a meal can be calculated as ...
    ...the sum of (meal_price - meal_cost) * order_quantity for a specific month.
    
Your query should also return the name of the eatery that is serving the meal. 
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Calculate the monthly Retention rate

/*
If 100 users where active in month 1 and then 80 of those were active again ...
    ... in month 2, the retention rate for that month would be 80%.

Your query should return a table showing the retention rate for each month...
    ... starting from June and ending in December. 
*/
-------------------------------------------------------------------------------



