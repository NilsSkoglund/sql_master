SELECT *
FROM bike_stores.production_categories;


-- Look into all different products in the "Cyclocross bicycles" category
SELECT *
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id
WHERE c.category_id = 4;

SELECT *
    , AVG(list_price) OVER (PARTITION BY c.category_id) as avg_category_list_price
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id
WHERE c.category_id = 4;



SELECT *
    , AVG(list_price) OVER (PARTITION BY c.category_id, p.brand_id) as avg_category_and_brand_list_price
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id
WHERE c.category_id = 4;

SELECT c.category_id 
    , any_value(c.category_name) as c_name
    , ROUND(AVG(list_price)) as avg_price
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id
GROUP BY category_id;


SELECT *
    , AVG(list_price) OVER (PARTITION BY c.category_id)
FROM bike_stores.production_categories as c
JOIN bike_stores.production_products as p
    ON c.category_id = p.category_id;
    
-------------------------------------------------------------------------------
-- medium emp start
-------------------------------------------------------------------------------


SELECT *
FROM emp.medium_emp as me
JOIN emp.salaries as s USING(emp_no)
JOIN emp.titles as t USING(emp_no)
WHERE s.to_date = "9999-01-01"
    AND t.to_date = "9999-01-01"


SELECT AVG(salary)
FROM emp.medium_emp as me
JOIN emp.salaries as s USING(emp_no)
JOIN emp.titles as t USING(emp_no)
WHERE s.to_date = "9999-01-01"
    AND t.to_date = "9999-01-01"
GROUP BY(title)


SELECT *,
    AVG(salary) OVER (partition by title)
FROM emp.medium_emp as me
JOIN emp.salaries as s USING(emp_no)
JOIN emp.titles as t USING(emp_no)
WHERE s.to_date = "9999-01-01"
    AND t.to_date = "9999-01-01"

SELECT *,
    AVG(salary) OVER (partition by title, gender)
FROM emp.medium_emp as me
JOIN emp.salaries as s USING(emp_no)
JOIN emp.titles as t USING(emp_no)
WHERE s.to_date = "9999-01-01"
    AND t.to_date = "9999-01-01"
    
-------------------------------------------------------------------------------
-- medium emp slut
-------------------------------------------------------------------------------
