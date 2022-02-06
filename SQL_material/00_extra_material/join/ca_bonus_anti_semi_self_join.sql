-------------------------------------------------------------------------------
-- Introducing Anti Join
-------------------------------------------------------------------------------
-- Open power point again and show theory slides on Anti Join
-- What you see here is the use of a subquery, which we will cover next
-- Get information on employees who never received a salary
SELECT *
FROM emp.employees AS e
WHERE e.emp_no NOT IN (
        SELECT s.emp_no
        FROM emp.salaries AS s
        );

-------------------------------------------------------------------------------
-- Introducing Semi Join
-------------------------------------------------------------------------------
-- show powerpoint slide on Semi Join
-- This is very similar to an INNER JOIN but only returns information
-- from the left table.
-- The oposite of an Anti Join
-- All employees that ever got a salary
SELECT *
FROM emp.employees AS e
WHERE e.emp_no IN (
        SELECT s.emp_no
        FROM emp.salaries AS s
        );


-------------------------------------------------------------------------------
-- Introducing Self Joins
-- Self Joins are also nothing new per se. They utilize inner joins but instead
-- of joining on another column, we can join a column on itself in clever ways
-- For this we utilize boolean logic in the ON clause
-------------------------------------------------------------------------------
-- for example: We want to Calculate the year over year salary increases in 
-- percent for every employee for every year.
SELECT s1.emp_no
    ,s1.salary AS sal_y1
    ,s2.salary AS sal_y2
    ,EXTRACT(year FROM s2.from_date) AS year
    ,((s2.salary / s1.salary) - 1) * 100 AS percent_change
FROM emp.salaries AS s1
INNER JOIN emp.salaries AS s2
    ON s1.emp_no = s2.emp_no
        AND EXTRACT(year FROM s1.from_date) = EXTRACT(year FROM s2.from_date) - 1
ORDER BY percent_change DESC;

-------------------------------------------------------------------------------
-- USING()
-- Introduce based on how the group is going.
-- Probably best to introduce during labs if people don't struggle with the
-- rest but feel frustrated with ON
-------------------------------------------------------------------------------