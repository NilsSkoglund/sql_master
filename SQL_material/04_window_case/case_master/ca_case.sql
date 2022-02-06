-------------------------------------------------------------------------------
-- Introducing CASE
-- BigQuery docs! 
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- We can use CASE in the SELECT clause to fill a column with values based ...
-- on if certain critera are met.
-- For example we can label employees based on the generation they belong to.
-------------------------------------------------------------------------------
SELECT CASE 
        WHEN birth_date BETWEEN "1946-01-01" AND "1964-12-31"
            THEN "BOOMER"
        WHEN birth_date BETWEEN "1965-01-01" AND "1980-12-31"
            THEN "GEN X"
        ELSE "OTHER"
        END AS gen_cat
FROM emp.employees;

-------------------------------------------------------------------------------
-- Or label employees whether they are currently employed or not
-------------------------------------------------------------------------------
SELECT emp_no
    ,CASE 
        WHEN to_date = '9999-01-01'
            THEN 'present'
        ELSE 'former'
        END AS STATUS
FROM emp.titles;

-------------------------------------------------------------------------------
-- These new categories can be used for counting an aggregation in subqueries
-- Count number of boomers and gen x in employees table
-------------------------------------------------------------------------------
SELECT gen_gat
    ,count(gen_cat)
FROM (
    SELECT CASE 
            WHEN birth_date BETWEEN "1946-01-01" AND "1964-12-31"
                THEN "BOOMER"
            WHEN birth_date BETWEEN "1965-01-01" AND "1980-12-31"
                THEN "GEN X"
            ELSE "OTHER"
            END AS gen_cat
    FROM emp.employees
    )
GROUP BY gen_cat;

------------------------------- THE END --------------------------------------