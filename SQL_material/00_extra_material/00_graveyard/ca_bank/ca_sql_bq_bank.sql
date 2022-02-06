-- overview
SELECT * FROM `material-1.ca_bank.account`;

SELECT * FROM `material-1.ca_bank.client`;

SELECT * FROM `material-1.ca_bank.disp`;

SELECT * FROM `material-1.ca_bank.loan`;

-- account
SELECT count(DISTINCT account_id) FROM `material-1.ca_bank.account`;

SELECT count(DISTINCT district_id) FROM `material-1.ca_bank.account`;

-- client
SELECT count(DISTINCT client_id) FROM `material-1.ca_bank.client`;


SELECT 
    gender, 
    count(gender)
FROM `material-1.ca_bank.client`
GROUP BY gender;


-- disp
SELECT 
    *
FROM `material-1.ca_bank.disp`;

SELECT
    count(DISTINCT disp_id),
    count(DISTINCT client_id),
    count(DISTINCT account_id)
FROM `material-1.ca_bank.disp`;

SELECT
    count(type) as count_type,
    type
FROM `material-1.ca_bank.disp`
GROUP BY type;

-- loan
SELECT
    count(DISTINCT loan_id)
FROM `material-1.ca_bank.loan`;

/*
5369 unique clients
4500 unique accounts
4 unique districts
682 loans
*/


/*
No. of loans in each district
*/

SELECT 
    count(loan_id) as loan_count,
    district_id
FROM 
    `material-1.ca_bank.loan` as l
        INNER JOIN 
    `material-1.ca_bank.account` as a 
        ON 
    l.account_id = a.account_id
GROUP BY 
    district_id
ORDER BY 
    loan_count DESC;


/*
No. of loans men & women
*/
SELECT 
    count(loan_id),
    gender
FROM 
    `material-1.ca_bank.loan` as l
        INNER JOIN 
    `material-1.ca_bank.disp` as d 
        ON 
    l.account_id = d.account_id
        INNER JOIN 
            `material-1.ca_bank.client` as c 
        ON 
    d.client_id = c.client_id
WHERE 
    type = "owner"
GROUP BY 
    gender;

/*
Average loan amount men & women
Copy & paste from previous question. Only changes are in the select statement
*/

SELECT 
    round(avg(amount)) as avg_amount,
    gender
    FROM 
        `material-1.ca_bank.loan` as l
            INNER JOIN 
        `material-1.ca_bank.disp` as d 
            ON 
        l.account_id = d.account_id
            INNER JOIN 
        `material-1.ca_bank.client` as c 
            ON 
        d.client_id = c.client_id
WHERE 
    type = "owner"
GROUP BY 
    gender;

-- End of warm up



-- CASE

/*
Calculate no. of good loans and number of bad loans

Type "A" and type "C" loans are "good loans"

Type "B" and type "C" loans are "bad loans" 
*/


SELECT 
    count(status) status_count, 
    status 
FROM 
    `material-1.ca_bank.loan` 
GROUP BY status;

SELECT 
    CASE 
    WHEN status in ("A", "C") THEN "good loan"
    ELSE "bad loan"
    END AS loan_status,
FROM 
    `material-1.ca_bank.loan`;


-- SUBQUERY / CTE 
# Subquery
/*
SELECT
    count(loan_status) AS status_count,
    loan_status
FROM (

-- insert subquery here!

)
group by loan_status;
*/
SELECT
    count(loan_status) AS status_count,
    loan_status
FROM (
SELECT 
    CASE 
    WHEN status in ("A", "C") THEN "good loan"
    ELSE "bad loan"
    END AS loan_status,
FROM `material-1.ca_bank.loan`
)
group by loan_status;
-- SHOW BIGQUERY DOCUMENTATION. IT IS NICE!. Just google bigquery case

# CTE 
/*
with temp_table AS
(
    -- insert query here
)

SELECT
    count(loan_status) as status_count, 
    loan_status
FROM temp_table 
GROUP BY loan_status;
*/
with temp_table AS
(SELECT 
    CASE 
    WHEN status in ("A", "C") THEN "good loan"
    ELSE "bad loan"
    END AS loan_status,
FROM `material-1.ca_bank.loan`)

SELECT
    count(loan_status) as status_count, 
    loan_status
FROM temp_table 
GROUP BY loan_status;

-- Try out a view?


-- CASE (including CTE & percentiles)

/*
Divide the loans into 3 groups, 1) small, 2) medium and 3) big - (Calculate the first and third quartile to decide on the boundaries)

Then calculate the mean loan duration per group.
*/

# calculate percentiles
SELECT
  -- Calculate the first and third quartile
  percentiles[offset(25)] as p25, 
  percentiles[offset(75)] as p75
FROM  (SELECT approx_quantiles(amount, 100) percentiles from `material-1.ca_bank.loan`);   


# case creating 3 categories
SELECT
    CASE
    WHEN amount < 66696 THEN "small loan"
    WHEN amount < 210744 THEN "medium loan"
    ELSE "big loan"
    END AS loan_cat,
FROM `material-1.ca_bank.loan`;

-- CTE
WITH loan_cats AS
(
SELECT
    CASE
    WHEN amount < 66696 THEN "small loan"
    WHEN amount < 210744 THEN "medium loan"
    ELSE "big loan"
    END AS loan_cat,
    duration
FROM `material-1.ca_bank.loan`
)
SELECT 
    loan_cat, 
    round(avg(duration)) as avg_duration
FROM loan_cats 
GROUP BY loan_cat
;

-- DATE TRUNC
-- Calculate no. of accounts created per month
SELECT
     date_trunc(date, month) as yr_mo,
     count(account_id) as counter_accounts
     FROM `material-1.ca_bank.account`
GROUP BY yr_mo
ORDER BY counter_accounts DESC;

-- Calculate no. of accounts created per year
SELECT
     date_trunc(date, year) as yr_mo,
     count(account_id) as counter_accounts
     FROM `material-1.ca_bank.account`
GROUP BY yr_mo
ORDER BY counter_accounts DESC;


-- Final Banger: Calculate the total amount due for each month from "C" & "D" loans
-- Step 1: DATE_ADD(date, interval duration month) as loan_due
-- Step 2: DATE_TRUNC() - Truncate loan due into monthly bins. Sum the installment that is due for the month
-- Step 3: SUM() OVER (ORDER BY ... DESC ROWS UNBOUNDED PRECEDING) 

WITH
  monthly_sum_due AS ( # CTE outer
  WITH
    running_due AS ( # CTE inner
-- STEP 1 ADD COLUMN loan due based on the duration and date columns
    SELECT
      installment,
      DATE_ADD(date, INTERVAL duration month) AS loan_due
    FROM
      `material-1.ca_bank.loan` 
    WHERE
      status IN ("C","D") ) -- Only looking at running contracts
-- STEP 2 Truncate loan_due into monthly bins. Sum the installment that is due for each month
  SELECT
    DATE_TRUNC(loan_due, month) AS year_month_due,
    SUM(installment) AS sum_last_installment
  FROM
    running_due
  GROUP BY
    year_month_due )
-- Step 3. Calculate cumsum of installments
SELECT
  *,
  SUM(sum_last_installment) OVER (ORDER BY year_month_due DESC ROWS UNBOUNDED PRECEDING) AS tot_monthly_repayments
FROM
  monthly_sum_due
ORDER BY
  year_month_due ASC;
  
-- Save query!

WITH temp_table AS
(
SELECT 
  SUM(installment) as amount_due,
  DATE_TRUNC(DATE_ADD(date, interval duration month), month) as loan_due,
  FROM `new-project-nod.NOD_db.loan`
WHERE status in ("C", "D")
GROUP BY loan_due
)
SELECT  
  SUM(amount_due) OVER(ORDER BY loan_due DESC ROWS UNBOUNDED PRECEDING) as tot_amount_due,
  loan_due
FROM temp_table
order by loan_due;