-------------------------------------------------------------------------------
-- deeper coverage of set theory and all the different joins possible in SQL
-------------------------------------------------------------------------------
-- SELF JOIN
WITH salary_per_year
AS (
    SELECT emp_no
        ,salary
        ,EXTRACT(year FROM from_date) AS year
    FROM employees.salaries
    )
SELECT t1.emp_no
    ,t1.salary AS sal_y1
    ,t2.salary AS sal_y2
    ,t2.year
    ,((t2.salary / t1.salary) - 1) * 100 AS percent_change
FROM salary_per_year AS t1
INNER JOIN salary_per_year AS t2
    ON t1.emp_no = t2.emp_no
        AND t1.year = t2.year - 1;

-- FULL JOIN

-- CROSS JOIN

-- UNION

-- INTERSECT

-- EXCEPT

-- semi joins and anti joins

-- anti join to check if a record is not included in another table
-- Select fields
select code, name
  -- From Countries
  from countries
  -- Where continent is Oceania
  where continent = 'Oceania'
  	-- And code not in
  	and code not in 
  	-- Subquery
  	(select code
  	 from currencies);