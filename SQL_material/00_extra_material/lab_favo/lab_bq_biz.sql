/* 
1) A customer with user id 33 has contacted customer support. She wants to know what her total bill on Favo is.
*/
 
 
/*
2) The first month of operations was June 2020. Calculate the total revenue for the first month.
*/
 
 
/*
3) Break down the revenue in June to weekly revenue. Did the sales increase week by week? Start the weeks with mondays.
*/
 
 
/*
4) Calculate Favos total cost for meals (from 2020-06-01 to 2020-12-31). 
 
Cost = meal_cost * stocked_quantity
*/
 
 
/*
5) Calculate the total cost for each meal_id. For which meal_id have they spent the most?
*/ 
 
/*
6) Calculate the monthly cost of meals for all 7 months
*/
 
 
/*
6.1) Calculate the monthly average cost for meals for the first 3 months of operations (June, July, August).
 
Your query should only return a single value. 
 
For this question, you are specifically instructed to solve it using a subquery
*/
 
 
/*
6.2) Calculate the monthly average cost of meals for the first 3 months of operations (June, July, August).
 
For this question, you are specifically instructed to solve it using a CTE (Common Table Expression)
*/
 
 
/*
6.3) Calculate the monthly average cost of meals for the first 3 months of operations (June, July, August).
 
For this question, you are specifically instructed to solve it using a saved view. 
    1. Save a view of the result table from the query in question 6
    2. Query that view
*/
 
 
/*
7) Calculate profit per eatery
 
Instructions for calculating profit:
    1. Revenue = sum(meal_price * order_quantity)
    2. Cost = sum(meal_cost * stocked_quantity)
    3. Profit = Revenue - Cost
*/
 
 
/*
8) Calculate profit per month
*/
 
 
/*
9) Calculate number of registrations per month
*/
 
 
/*
9.1) Calculate cumulative sum of regististrations per month
*/
 
 
/*
10) Calculate average revenue per user
*/
 
 
/*
10.1) Calculate average revenue per user(ARPU) per week
 
Your query should return a table showing the development of ARPU per week from the first week through to the last week. 
*/
 
 
/*
11) Assign the users into 3 different categories based on their total generated revenue.
 
    1. Users generating less than 150 in revenue = “low rev users”
    2. Users who have generated between 150 and 300 in revenue = “mid rev users”
    3. Users generating more than 300 in revenue = “high rev users”
 
Your query should return the frequency count for each category.
*/


/*
Lab finished, well done.

Bonus challenges below!
*/


/*
Bonus 1) 
Calculate the growth rate of monthly active users(MAU). 

A user is defined as a monthly active user if he/she has made at least one order during the given month.

Your query should return a table showing the monthly percentage growth rate of MAU starting from June (where the growth rate will be null since it is the first month) and ending in december
*/

/*
Bonus 2) 
Each month there is a contest for the meals that have generated the most profit. 

Write a query that returns the top five ranked meals in terms of monthly generated profit. 

For this question, the profit for a meal can be calculated as the sum of (meal_price - meal_cost) * order_quantity for a specific month. 

Your query should also return the name of the eatery that is serving the meal. 
*/

/*
Bonus 3) 
Calculate the monthly retention rate. 

If 100 users where active in month 1 and then 80 of those were active again in month 2, the retention rate for that month would be 80%.

Your query should return a table showing the retention rate for each month, starting from June and ending in December. 
*/
