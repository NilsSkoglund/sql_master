SELECT emp_no
    ,salary AS sal_current
    ,LAG(salary, 1) OVER year_window AS sal_before
    ,extract(year FROM from_date) AS current_year
    ,lag(extract(year FROM from_date)) OVER year_window AS before_year
    ,((salary / LAG(salary, 1) OVER year_window) - 1) * 100 AS 
    percent_change
FROM employees.salaries window year_window AS (
        PARTITION BY emp_no ORDER BY extract(year FROM from_date)
        )
ORDER BY percent_change DESC;