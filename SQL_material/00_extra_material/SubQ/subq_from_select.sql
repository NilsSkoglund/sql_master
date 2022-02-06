-------------------------------------------------------------------------------
-- SubQueries inside FROM
-- We can use SubQueries inside FROM to select from or JOIN with
-- This is often useful in combination with aggregation functions
-------------------------------------------------------------------------------
-- get the average total budget spent on employee salaries by departments
SELECT avg(tot_sal_spending) AS avg_tot_sal_spending
FROM (
    SELECT sum(s.salary) AS tot_sal_spending
    FROM emp.salaries AS s
    INNER JOIN emp.dept_emp AS de
        ON s.emp_no = de.emp_no
    GROUP BY s.salary
    );

-- Lets say we want to get the fraction of employees with a current salary over
-- all employees that ever worked at the company.
-- We can solve this by using multiple subquerries
SELECT COUNT(cs.emp_no) / COUNT(e.emp_no) AS fraction_emps_w_sal
FROM emp.employees AS e
LEFT JOIN (
    SELECT emp_no
    FROM emp.salaries
    WHERE to_date = '9999-01-01'
    ) AS cs
    ON e.emp_no = cs.emp_no;
    
    
    
-------------------------------------------------------------------------------
-- Subqueries inside SELECT
-- We can use subqueries inside SELECT. Most often useful in combination with
-- CASE more on that in the CASE code along
-------------------------------------------------------------------------------
-- get avg. salary per employee
-- get max salary per employee
SELECT e.emp_no
    ,first_name
    ,last_name
    ,hire_date
    ,(
        SELECT avg(salary)
        FROM emp.salaries AS s
        WHERE e.emp_no = s.emp_no
        ) AS avg_sal 
    ,(
        SELECT max(salary)
        FROM emp.salaries AS s
        WHERE e.emp_no = s.emp_no
        ) AS max_sal
FROM emp.employees AS e
ORDER BY max_sal DESC;