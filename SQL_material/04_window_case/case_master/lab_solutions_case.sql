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
SELECT emp_no
    ,CASE 
        WHEN title IN ("Engineer", "Senior Engineer", "Assistant Engineer"
                )
            THEN "Engineer"
        WHEN title IN ("Staff", "Senior Staff")
            THEN "Staff"
        ELSE "Managers"
        END AS title_cat
FROM emp.titles;


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
SELECT count(*) as staff_count
    ,CASE 
        WHEN title IN ("Engineer", "Senior Engineer", "Assistant Engineer"
                )
            THEN "Engineer"
        WHEN title IN ("Staff", "Senior Staff")
            THEN "Staff"
        ELSE "Managers"
        END AS title_cat
FROM emp.titles
WHERE to_date = "9999-01-01"
group by title_cat;

-------------------------------------------------------------------------------
-- use the food delivery dataset
-- EXCERCISE 3:
-- Create new categories for the meals in the meals table based on the meal price
    -- IF < 4 THEN "low", 
    -- IF < 5 THEN "medium", 
    -- ELSE "high"
-------------------------------------------------------------------------------
SELECT * 
    ,CASE 
        WHEN meal_price < 4
            THEN "low"
        WHEN meal_price < 5
            THEN "medium"
        ELSE "high"
        END AS price_cat
FROM food_delivery.meals



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


SELECT COUNT(*) AS cat_count
    ,CASE 
        WHEN meal_price < 4
            THEN "low"
        WHEN meal_price < 5
            THEN "medium"
        ELSE "high"
        END AS price_cat
FROM food_delivery.meals
GROUP BY price_cat


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
SELECT emp_no
    ,salary
    ,CASE 
        WHEN salary < (
                SELECT avg(salary)
                FROM emp.salaries
                ) - 20000
            THEN 'Low'
        WHEN salary > (
                SELECT avg(salary)
                FROM emp.salaries
                ) + 20000
            THEN 'High'
        ELSE 'Medium'
        END AS sal_cat
FROM emp.salaries;


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
SELECT CASE 
        WHEN emp_no IN (
                SELECT emp_no
                FROM emp.titles
                WHERE title = 'Manager'
                AND to_date = "9999-01-01"
                )
            THEN 'Manager'
        ELSE 'Employee'
        END AS emp_cat
    ,CASE 
        WHEN salary < (
                SELECT avg(salary)
                FROM emp.salaries
                ) - 20000
            THEN 'Low'
        WHEN salary > (
                SELECT avg(salary)
                FROM emp.salaries
                ) + 20000
            THEN 'High'
        ELSE 'Medium'
        END AS sal_cat
    ,count(*) AS counts
FROM emp.salaries
WHERE to_date = '9999-01-01'
GROUP BY emp_cat
    ,sal_cat;