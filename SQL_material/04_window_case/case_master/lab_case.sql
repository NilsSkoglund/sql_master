-------------------------------------------------------------------------------
-------------------------------------- CASE -----------------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Use the emp dataset
-- EXCERCISE 1:
-- Create new categories for the titles. Categorize them as Engineers, Staff
-- or Managers. Retrieve a table where these new categories are connected to
-- the emp_no.
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- Now modify the query from above so that you count the number of active
-- employees in each category that you created.

/*
staff_count	title_cat
107550	Staff
12064	Managers
120510	Engineer
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- use the food delivery dataset
-- EXCERCISE 3:
-- Create new categories for the meals in the meals table based on the meal price
    -- IF < 4 THEN "low", 
    -- IF < 5 THEN "medium", 
    -- ELSE "high"
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 4:
-- Now modify the query from above so that you count the number ...
-- ... of meals in each category

/*
cat_count	price_cat
8	medium
6	low
6	high
*/
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-------------------------- Lab finished, Well done ----------------------------
----------------------------- BONUS QUESTIONS ---------------------------------
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- use the food delivery dataset
-- Bonus 1:
-- Create new categories for the meals in the meals table based on ...
-- ... the profit per meal
    -- IF < 3 THEN "low", 
    -- IF < 4 THEN "medium", 
    -- ELSE "high"
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- use the emp dataset
-- Bonus 2:
-- Create a new category for different levels of salary.
-- Medium: 20000 +- of the average salary
-- Low: below Medium, High: above medium
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- EXCERCISE 3:
-- Modify the above query so that you count the number of employees and managers
-- in each category. Do this only for the currently employed

/*
emp_cat	sal_cat	counts
Employee	High	18985
Employee	Medium	61667
Employee	Low	974
Manager	High	2
Manager	Medium	7
*/
-------------------------------------------------------------------------------



