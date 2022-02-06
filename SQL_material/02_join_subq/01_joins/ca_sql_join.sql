-------------------------------------------------------------------------------
-- Introducing JOIN
-- If we want to combine information that is stored accross multiple tables,
-- we have to use JOIN
-------------------------------------------------------------------------------
-- We have to declare with ON what value describes the relationship between
-- both tables. Also called the key.
SELECT *
FROM emp.employees
INNER JOIN emp.salaries
    ON emp.emp_no = salaries.emp_no;


-- We can make this easier to type (but somewhat harder to read) with AS
-- Still, this is generally best practice to do.
SELECT *
FROM emp.employees AS s
INNER JOIN emp.salaries AS e
    ON e.emp_no = s.emp_no;


-------------------------------- no codealong ---------------------------------

-- Code to create table "mini_emp"
SELECT *
FROM emp.employees
WHERE emp_no IN (54342, 294868)

-- Show the students the mini_emp table and what it contains
SELECT *
FROM emp.mini_emp;
--------------------------- end of no codealong -------------------------------

-------------------------------------------------------------------------------
-- JOINS work according to the rules of set theory.
-- They can be visualized with Venn diagrams. **Show cheat sheet**
-- INNER and LEFT joins most commonly used joins
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Introducing INNER JOIN
-- The intersection between the left (A) and right (B) table
-------------------------------------------------------------------------------
-- There is no record of emp_no 294868 in the salaries table.
-- So it won't included when we are doing an INNER JOIN
-- This is the most generally useful JOIN
-- Make sure this makes sense to everyone. Refer to cheat sheet.
SELECT *
FROM emp.mini_emp AS A
INNER JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no;

-------------------------------------------------------------------------------
-- Column name ... is ambiguous
-- A problem that shows up when we start using JOINs
-------------------------------------------------------------------------------
SELECT emp_no
    ,first_name
    ,last_name
    ,salary
FROM emp.mini_emp AS me
INNER JOIN emp.salaries AS s
    ON me.emp_no = s.emp_no;

-- This is ambigious and leads to errors
-- emp_no exists in both:
    -- the mini_emp table
    -- and the salaries table
-- Therefore... ambiguous!


-- dealing with ambiguity in select
-- Specify a table name before the column name
-- for emp_no it is nessecary, for the others it's good practice
SELECT me.emp_no
    ,me.first_name
    ,me.last_name
    ,s.salary
FROM emp.mini_emp AS me
INNER JOIN emp.salaries AS s
    ON me.emp_no = s.emp_no;
    
-------------------------------------------------------------------------------
-- Introducing LEFT JOIN
-- Everything from A (left) including the intersection with B (right)
-------------------------------------------------------------------------------
-- With the LEFT JOIN we are always including the records from the left table
-- Keys without any info in B will simply have NULL there instead
-- The left table is the first table. So mini_emp in this case
-- Make sure this makes sense to everyone. Refer to cheat sheet.
SELECT *
FROM emp.mini_emp AS A
LEFT JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no;


-- Adding in IS NULL 
SELECT *
FROM emp.mini_emp AS A
LEFT JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no
WHERE B.salary IS NULL;
-- IS NULL can be used on any column in the right table 

-- Let's say we wan't to get all employee numbers ...
-- ... for employees that never received a salary 

-- just change mini_emp to employees
SELECT *
FROM emp.employees AS A
LEFT JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no
WHERE B.salary IS NULL;

-- Being a bit more specific with DISTINCT(A.emp_no)
SELECT DISTINCT(A.emp_no)
FROM emp.employees AS A
LEFT JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no
WHERE B.salary IS NULL;

-------------------------------------------------------------------------------
-- Summary LEFT JOIN
-- Everything from A (left table) 
-- Add in records from B (right table)
-- Rows from A without any info in B will have NULL there instead
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- INNER JOINs are much more commonly used 
-- We don't even have to specify the INNER part
-------------------------------------------------------------------------------
SELECT *
FROM emp.mini_emp AS A
-- JOIN = INNER JOIN
    JOIN emp.salaries AS B
    ON A.emp_no = B.emp_no;
-- Show student's that the result is the same
    
-------------------------------------------------------------------------------
-- Lets find out some more info about our two employees
-------------------------------------------------------------------------------
-- what is the title for all employees?
SELECT me.first_name
    ,me.last_name
    ,t.title
FROM emp.mini_emp AS me
INNER JOIN emp.titles AS t
    ON me.emp_no = t.emp_no;


-- which department are they working in?
SELECT me.first_name
    ,me.last_name
    ,de.dept_no
FROM emp.mini_emp AS me
INNER JOIN emp.dept_emp AS de
    ON me.emp_no = de.emp_no;


-------------------------------------------------------------------------------
-- We can also combine multiple JOINS in one query
-------------------------------------------------------------------------------
-- what is the name of the department?
-- We need to match mini_emp with dept_emp using emp_no
    -- to get the dept_no
-- Then we need to match dept_emp with departments on dept_no
    -- to get the dept_name from departments
SELECT me.first_name
    ,me.last_name
    ,de.dept_no
    ,d.dept_name
FROM emp.mini_emp AS me
INNER JOIN emp.dept_emp AS de
    ON me.emp_no = de.emp_no
INNER JOIN emp.departments AS d
    ON de.dept_no = d.dept_no;
    
-------------------------------------------------------------------------------
------------------- Finally before we jump into the lab ... -------------------
--------------------------- A note on Data Cleaning ---------------------------
-- Open up Theory Slides
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Now let’s explore with code how our error came about
-- (no codealong)
-------------------------------------------------------------------------------
-- Table with all info
SELECT 
    *
FROM emp.salaries as s
JOIN emp.employees as e
    on e.emp_no = s.emp_no
JOIN emp.titles as t
    on e.emp_no = t.emp_no
WHERE title = "Senior Engineer";

-- Copy & paste + change from * to Calc of avg. salary
SELECT 
    AVG(s.salary)
FROM emp.salaries as s
JOIN emp.employees as e
    on e.emp_no = s.emp_no
JOIN emp.titles as t
    on e.emp_no = t.emp_no
WHERE title = "Senior Engineer";

-- Returns 60552, below industry average
-- This is the number that we reported to management
-- What is wrong with this number?
-- Ask students, let them think about it for a bit

-- Copy & paste + change from avg(salary) to *
-- add in ORDER BY
-- Let students view output table & see if they find the problem
SELECT 
    *
FROM emp.salaries as s
JOIN emp.employees as e
    on e.emp_no = s.emp_no
JOIN emp.titles as t
    on e.emp_no = t.emp_no
WHERE title = "Senior Engineer"
ORDER BY e.emp_no;

-- All salaries each employee has had as a Senior Enginner is shown
-- We only wan't to calculate the current salary they have

-- Copy & paste + add in a new condition in the WHERE clause
SELECT 
    *
FROM emp.salaries as s
JOIN emp.employees as e
    on e.emp_no = s.emp_no
JOIN emp.titles as t
    on e.emp_no = t.emp_no
WHERE title = "Senior Engineer"
    AND s.to_date = "9999-01-01" -- only current salaries
ORDER BY e.emp_no;

-- from 387911 rows to 29286 rows with the new condition

-- Copy & paste + change from * to Calc of avg. salary
-- and remove ORDER BY
SELECT 
    AVG(s.salary)
FROM emp.salaries as s
JOIN emp.employees as e
    on e.emp_no = s.emp_no
JOIN emp.titles as t
    on e.emp_no = t.emp_no
WHERE title = "Senior Engineer"
    AND s.to_date = "9999-01-01" -- only current salaries;
    
-- Returns 70845, above industry average!

-- from 60552 to 70845
-- a 10 000 change because of the 1 line of code:
    -- AND s.to_date = "9999-01-01"

-------------------------------------------------------------------------------
--------------------------- Data Cleaning Wrap Up -----------------------------
-- We wanted to calculate the average salaries of "senior engineers"

-- We only wanted to look at current salary data
-- so we "cleaned" our data
-- "removing" irrelevant data
-------------------------------------------------------------------------------
----------------------------------- THE END -----------------------------------

-- Lab time!