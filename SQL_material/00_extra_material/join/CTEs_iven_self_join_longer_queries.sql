-- Q1 --
-- Calculate the year over year salary increases in percent for every employee for every year

WITH
    salary_per_year AS
(
    SELECT 
      emp_no, 
      salary, 
      EXTRACT(year from from_date) AS year
    FROM
      emp.salaries   
)
SELECT 
  t1.emp_no,
  t1.salary AS sal_y1,
  t2.salary AS sal_y2,
  t2.year,
  ((t2.salary / t1.salary)-1) * 100 AS percent_change
FROM
  salary_per_year AS t1
    INNER JOIN
  salary_per_year as t2
    ON
  t1.emp_no = t2.emp_no
  AND t1.year = t2.year-1
;  

-- Q2 -- calculate the average raise in perc year over year per department 

-- First Q1 again as a first step

WITH
  salary_per_year AS (
  SELECT
    emp_no,
    salary,
    EXTRACT(year
    FROM
      from_date) AS year
  FROM
    emp.salaries ),

  perc_p_year AS (
  SELECT
    t1.emp_no,
    t1.salary AS sal_y1,
    t2.salary AS sal_y2,
    t2.year,
    ((t2.salary - t1.salary) / t1.salary * 100) AS perc_inc
  FROM
    salary_per_year AS t1
  INNER JOIN
    salary_per_year AS t2
  ON
    t1.emp_no = t2.emp_no
    AND t1.year = t2.year - 1)

-- Now the next step, calculating the average raise in perc year over year per department    

SELECT
  de.dept_no,
  py.year,
  AVG(py.perc_inc ) AS avg_perc_inc
FROM
  perc_p_year AS py
INNER JOIN
  emp.dept_emp AS de
USING
  (emp_no)
GROUP BY
  de.dept_no,
  py.year
ORDER BY
  py.year,
  avg_perc_inc;