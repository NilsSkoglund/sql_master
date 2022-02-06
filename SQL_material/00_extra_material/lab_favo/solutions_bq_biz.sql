/* 
1) A customer with user id 33 has contacted customer support. She wants to know what her total bill on Favo is.
*/
SELECT
  SUM(meal_price * order_quantity) as sum_15
FROM
  `material-1.sql_bizniz.orders` AS orders
JOIN
  `material-1.sql_bizniz.meals` AS meals
ON
  meals.meal_id = orders.meal_id
WHERE
  user_id = (33);

-- correct answer = 400.5
 
/*
2) The first month of operations was June 2020. Calculate the total revenue for the first month.
*/
SELECT
  MIN(order_date) as start_date,
  MAX(order_date) as end_date,
  SUM(order_quantity * meal_price) AS sum_revenue
FROM
  `material-1.sql_bizniz.meals` AS meals
JOIN
  `material-1.sql_bizniz.orders` AS orders
ON
  meals.meal_id = orders.meal_id
WHERE
  order_date BETWEEN '2020-06-01'
  AND '2020-06-30'; 
  
-- correct answer = 6551
 
/*
3) Break down the revenue in June to weekly revenue. Did the sales increase week by week? Start the weeks with mondays.
*/
SELECT
  DATE_TRUNC(order_date, week(monday)) AS week_starting_date,
  SUM(order_quantity * meal_price) AS weekly_revenue
FROM
  `material-1.sql_bizniz.meals` AS meals
JOIN
  `material-1.sql_bizniz.orders` AS orders
ON
  meals.meal_id = orders.meal_id
WHERE
  order_date BETWEEN '2020-06-01'
  AND '2020-06-30'
GROUP BY
  week_starting_date; 
  
-- Correct answer: No it did not, (1464, 1601, 1947, 1259, 279) 
 
/*
4) Calculate Favos total cost for meals (from 2020-06-01 to 2020-12-31). 
 
Cost = meal_cost * stocked_quantity
*/
SELECT
  SUM(meal_cost * stocked_quantity)
FROM
  `material-1.sql_bizniz.stock` AS stock
JOIN
  `material-1.sql_bizniz.meals` AS meals
ON
  meals.meal_id = stock.meal_id; 
  
-- Correct answer: 92133  
  
/*
5) Calculate the total cost for each meal_id. For which meal_id have they spent the most?
*/ 
SELECT
  -- Calculate cost per meal ID
  meals.meal_id,
  sum(stocked_quantity * meal_cost) AS cost
FROM `material-1.sql_bizniz.meals` AS meals
JOIN `material-1.sql_bizniz.stock` AS stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
ORDER BY cost DESC
-- Only the top 3 meal IDs by purchase cost
LIMIT 3;

-- correct answer: meal_id 5 (12248)

/*
6) Calculate the monthly cost of meals for all 7 months
*/
SELECT
  DATE_TRUNC(stocking_date, month) AS stocking_month,
  SUM(stocked_quantity * meal_cost) AS monthly_cost
FROM
  `material-1.sql_bizniz.meals` AS meals
JOIN
  `material-1.sql_bizniz.stock` AS stock
ON
  meals.meal_id = stock.meal_id
GROUP BY
  stocking_month
ORDER BY
  stocking_month ASC; 

-- [2222.75, 3594.25, 5365.75, 8480.0, 12488.75


/*
6.1) Calculate the monthly average cost for meals for the first 3 months of operations (June, July, August).
 
Your query should only return a single value. 
 
For this question, you are specifically instructed to solve it using a subquery
*/
SELECT
  AVG(monthly_cost)
FROM (
  SELECT
    DATE_TRUNC(stocking_date, month) AS stocking_month,
    SUM(stocked_quantity * meal_cost) AS monthly_cost
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.stock` AS orders
  ON
    meals.meal_id = orders.meal_id
  GROUP BY
    stocking_month
  ORDER BY
    stocking_month ASC
)
WHERE
  stocking_month < '2020-09-01'; 
 
/*
6.2) Calculate the monthly average cost of meals for the first 3 months of operations (June, July, August).
 
For this question, you are specifically instructed to solve it using a CTE (Common Table Expression)
*/
WITH
  months AS (
  SELECT
    DATE_TRUNC(stocking_date, month) AS stocking_month,
    SUM(stocked_quantity * meal_cost) AS monthly_cost
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.stock` AS stock
  ON
    meals.meal_id = stock.meal_id
  GROUP BY
    stocking_month
  ORDER BY
    stocking_month ASC )
SELECT
  AVG(monthly_cost)
FROM
  months
WHERE
  stocking_month < '2020-09-01'; 
 
/*
6.3) Calculate the monthly average cost of meals for the first 3 months of operations (June, July, August).
 
For this question, you are specifically instructed to solve it using a saved view. 
    1. Save a view of the result table from the query in question 6
    2. Query that view
*/
SELECT
  AVG(monthly_cost)
FROM
  `material-1.sql_bizniz.meals_monthly_cost`
WHERE
  stocking_month < '2020-09-01'; 
 
/*
7) Calculate profit per eatery
 
Instructions for calculating profit:
    1. Revenue = sum(meal_price * order_quantity)
    2. Cost = sum(meal_cost * stocked_quantity)
    3. Profit = Revenue - Cost
*/
WITH
--- Creating temporary table revenue
  revenue AS (
  SELECT
    meals.eatery,
    SUM(meal_price * order_quantity) AS revenue
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.orders` AS orders
  ON
    meals.meal_id = orders.meal_id
  GROUP BY
    meals.eatery ),
--- Creating temporary table cost
  cost AS (
  SELECT
    meals.eatery,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.stock` AS stock
  ON
    meals.meal_id = stock.meal_id
  GROUP BY
    meals.eatery )
--- Joining tables revenue and cost and calculating profit
SELECT
  r.eatery,
  r.revenue,
  c.cost,
  (revenue - cost) AS profit
FROM
  revenue AS r
JOIN
  cost AS c
ON
  c.eatery = r.eatery
ORDER BY
  profit DESC; 
 
/*
8) Calculate profit per month
*/
WITH
--- CTE 
  revenue AS (
  SELECT
    DATE_TRUNC(order_date, month) AS order_month,
    SUM(order_quantity * meal_price) AS monthly_revenue
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.orders` AS orders
  ON
    meals.meal_id = orders.meal_id
  GROUP BY
    order_month),
 --- CTE 
  cost AS (
  SELECT
    DATE_TRUNC(stocking_date, month) AS stocking_month,
    SUM(stocked_quantity * meal_cost) AS monthly_cost
  FROM
    `material-1.sql_bizniz.meals` AS meals
  JOIN
    `material-1.sql_bizniz.stock` AS stock
  ON
    meals.meal_id = stock.meal_id
  GROUP BY
    stocking_month)
--- Joining and selecting from both CTE:s
SELECT
  order_month,
  monthly_cost,
  monthly_revenue,
  (monthly_revenue - monthly_cost) AS monthly_profit
FROM
  revenue
JOIN
  cost
ON
  revenue.order_month = cost.stocking_month;
 
/*
9) Calculate number of registrations per month
*/
WITH
  reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM
    `material-1.sql_bizniz.orders`
  GROUP BY
    user_id)
SELECT
  DATE_TRUNC(reg_date, month) AS delivr_month,
  COUNT(user_id) AS regs
FROM
  reg_dates
GROUP BY
  delivr_month
ORDER BY
  delivr_month ASC; 
 
/*
9.1) Calculate cumulative sum of regististrations per month
*/
WITH
  reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM
    `material-1.sql_bizniz.orders`
  GROUP BY
    user_id),
  regs_tot AS (
  SELECT
    DATE_TRUNC(reg_date, month) AS delivr_month,
    COUNT(DISTINCT user_id) AS reg
  FROM
    reg_dates
  GROUP BY
    delivr_month)
SELECT
  delivr_month,
  SUM(reg) OVER (ORDER BY delivr_month) AS regs_rt
FROM
  regs_tot
ORDER BY
  delivr_month ASC; 
 
/*
10) Calculate average revenue per user
*/
WITH kpi as (
  SELECT
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM `material-1.sql_bizniz.meals` AS m
  JOIN `material-1.sql_bizniz.orders` AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)
SELECT ROUND(AVG(revenue), 2) AS arpu
FROM kpi; 
 
/*
10.1) Calculate average revenue per user(ARPU) per week
 
Your query should return a table showing the development of ARPU per week from the first week through to the last week. 
*/
WITH kpi AS (
  
  SELECT
    DATE_TRUNC(order_date, week) AS delivr_week,
    sum(order_quantity * meal_price) AS revenue,
    count(distinct user_id) AS users
  FROM `material-1.sql_bizniz.meals` AS m
  JOIN `material-1.sql_bizniz.orders` AS o ON m.meal_id = o.meal_id
  GROUP BY delivr_week
)

SELECT
  delivr_week,
  ROUND(revenue / users, 2) AS arpu
FROM kpi
ORDER BY delivr_week ASC; 
 
/*
11) Assign the users into 3 different categories based on their total generated revenue.
 
    1. Users generating less than 150 in revenue = “low rev users”
    2. Users who have generated between 150 and 300 in revenue = “mid rev users”
    3. Users generating more than 300 in revenue = “high rev users”
 
Your query should return the frequency count for each category.
*/
WITH user_revenues AS (
  SELECT
    user_id,
    sum(order_quantity * meal_price) AS revenue
  FROM `material-1.sql_bizniz.meals` AS m
  JOIN `material-1.sql_bizniz.orders` AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  CASE
    WHEN revenue < 150 THEN 'Low-revenue users'
    WHEN revenue < 300 THEN 'Mid-revenue users'
    ELSE 'High-revenue users'
  END AS revenue_group,
  count(user_id) AS users
FROM user_revenues
GROUP BY revenue_group;

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
WITH mau_t AS (
  SELECT
    DATE_TRUNC(order_date, month)  AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM `material-1.sql_bizniz.orders`
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
      LAG(mau) OVER (ORDER BY delivr_month ASC) AS last_mau
  FROM mau_t)

SELECT
  delivr_month,
  round((mau - last_mau) / last_mau, 2) AS mau_delta
FROM mau_with_lag
ORDER BY delivr_month ASC;

/*
Bonus 2) 
Each month there is a contest for the meals that have generated the most profit. 

Write a query that returns the top five ranked meals in terms of monthly generated profit. 

For this question, the profit for a meal can be calculated as the sum of (meal_price - meal_cost) * order_quantity for a specific month. 

Your query should also return the name of the eatery that is serving the meal. 
*/
WITH meal_revenue_rank_table AS
(
  SELECT
    any_value(eatery) as eatery,
    DATE_TRUNC(order_date, month) as month,
    m.meal_id,
    sum((meal_price - meal_cost) * order_quantity) AS meal_revenue
  FROM `material-1.sql_bizniz.orders` as o 
  JOIN `material-1.sql_bizniz.meals` AS m ON m.meal_id = o.meal_id
  GROUP BY meal_id, month
)
SELECT
  eatery,
  month,
  meal_id,
  meal_revenue, 
  RANK() OVER (ORDER BY meal_revenue DESC) AS meal_revenue_rank
FROM meal_revenue_rank_table
ORDER BY meal_revenue_rank, month ASC
LIMIT 5;

/*
Bonus 3) 
Calculate the monthly retention rate. 

If 100 users where active in month 1 and then 80 of those were active again in month 2, the retention rate for that month would be 80%.

Your query should return a table showing the retention rate for each month, starting from June and ending in December. 
*/
WITH
  user_monthly_activity AS (
  SELECT
    DISTINCT DATE_TRUNC(order_date, month) AS delivr_month,
    user_id
  FROM
    `material-1.sql_bizniz.orders`)
SELECT
  previous_mo.delivr_month as previous_month,
  count(DISTINCT previous_mo.user_id) as previous_months_users,
  count(DISTINCT current_mo.user_id) as no_who_has_stayed,
  round(COUNT(DISTINCT current_mo.user_id) / GREATEST(COUNT(DISTINCT previous_mo.user_id),1),2) as retention_rate
FROM
  user_monthly_activity AS previous_mo
LEFT JOIN
  user_monthly_activity AS current_mo
ON
  previous_mo.user_id = current_mo.user_id
  AND previous_mo.delivr_month = (current_mo.delivr_month - INTERVAL 1 month)
GROUP BY
  previous_mo.delivr_month
ORDER BY
  previous_mo.delivr_month;