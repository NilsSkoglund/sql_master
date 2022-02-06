# GENERAL INFORMATION ABOUT THIS LAB
# The difficult part of this lab is not writing the actual queries. The challenge here is to understand what tables to use to get the desired output. 

use publications;

###############################################################
###############################################################
####################### QUESTION 1 ############################
###############################################################
###############################################################

#  What authors Have Published What At What/Which Publisher?


SELECT 
    a.au_id, a.au_lname, a.au_fname, t.title, p.pub_name
FROM
    authors a
        JOIN
    titleauthor ta ON ta.au_id = a.au_id
        JOIN
    titles t ON t.title_id = ta.title_id
        JOIN
    publishers p ON p.pub_id = t.pub_id
ORDER BY a.au_id ASC;



###############################################################
###############################################################
####################### QUESTION 2 ############################
###############################################################
###############################################################

# Who Have Published How Many different Books At What/Which Publisher?

-- Teacher's note: It is important to group by au_id and then by au_fname since some books have been co-authored!

SELECT 
    a.au_id,
    a.au_lname,
    a.au_fname,
    COUNT(*) AS title_count,
    p.pub_name
FROM
    authors a
        JOIN
    titleauthor ta ON ta.au_id = a.au_id
        JOIN
    titles t ON t.title_id = ta.title_id
        JOIN
    publishers p ON p.pub_id = t.pub_id
GROUP BY a.au_id , p.pub_name;


###############################################################
###############################################################
####################### QUESTION 3 ############################
###############################################################
###############################################################

# Write a Query that Gives us the Best Selling Authors and Rank them from high to low.
-- Teacher's note: Group By au_id (unique)

SELECT 
    a.au_id, a.au_lname, a.au_fname, SUM(s.qty) AS total
FROM
    authors a
        LEFT JOIN
    titleauthor ta ON ta.au_id = a.au_id
        LEFT JOIN
    titles t ON t.title_id = ta.title_id
        LEFT JOIN
    sales s ON s.title_id = t.title_id
GROUP BY a.au_id
ORDER BY total DESC;

###############################################################
###############################################################
####################### QUESTION 4 ############################
###############################################################
###############################################################



#### Calculate the royalties of each sales for each author and then save your result in a temporary table. 
### HINT: If you don't know how to create a temporary table, use Google to find out.

-- Teacher's note: Formula for calculating RoyPerSale = price * qty * royalty/100 (roy is exp as int.) * royaty per authour/100 (some books are
-- co-authored and royaltyper is the split of royalty per author)

SELECT 
    ta.title_id,
    ta.au_id,
    (ti.price * sales.qty * ti.royalty / 100 * ta.royaltyper / 100) AS RoyPerSale
FROM
    titleauthor ta
        INNER JOIN
    titles ti ON ta.title_id = ti.title_id
        INNER JOIN
    sales ON ti.title_id = sales.title_id;


CREATE TEMPORARY TABLE RoyPerSaleTable
SELECT 
    ta.title_id,
    ta.au_id,
    (ti.price * sales.qty * ti.royalty / 100 * ta.royaltyper / 100) AS RoyPerSale
FROM
    titleauthor ta
        INNER JOIN
    titles ti ON ta.title_id = ti.title_id
        INNER JOIN
    sales ON ti.title_id = sales.title_id;


###############################################################
###############################################################
####################### QUESTION 5 ############################
###############################################################
###############################################################


#### Using the temporary table from the previous question, aggregate the total royalties for each title and then for each author. Then save the results to a temporary table.
SELECT 
    title_id, au_id, SUM(RoyPerSale) AS RoyalSum
FROM
    RoyPerSaleTable
GROUP BY title_id , au_id
;

create temporary table RoyPerSaleTableV2
SELECT 
    title_id, au_id, SUM(RoyPerSale) AS RoyalSum
FROM
    RoyPerSaleTable
GROUP BY title_id , au_id
;




###############################################################
###############################################################
####################### QUESTION 6 ############################
###############################################################
###############################################################

### Calculate the total profits of each author
# HINT: You will have to create a formula for calculating the profits.

-- Teacher's note: To calculate the profits in total we need to take the advance payements into consideration!
SELECT 
    r.au_id,
    (r.RoyalSum + (ta.royaltyper / 100) * (ti.advance)) AS TotalProfits
FROM
    RoyPerSaleTableV2 r
        INNER JOIN
    titles ti ON r.title_id = ti.title_id
        INNER JOIN
    titleauthor ta ON r.au_id = ta.au_id
ORDER BY TotalProfits DESC
LIMIT 3;

###############################################################
###############################################################
########################  QUESTION 7 ##########################
###############################################################
###############################################################

# Acquire the sam the results as you got in Question 4-6, but by writing a subquery. Explain the connection between your temporary tables
# and the subquery in this question. 


SELECT 
    r.au_id,
    (r.RoyalSum + (ta.royaltyper / 100) * (ti.advance)) AS TotalProfits
FROM
    (SELECT 
        title_id, au_id, SUM(RoyPerSale) AS RoyalSum
    FROM
        (SELECT 
        ta.title_id,
            ta.au_id,
            (ti.price * sales.qty * ti.royalty / 100 * ta.royaltyper / 100) AS RoyPerSale
    FROM
        titleauthor ta
    INNER JOIN titles ti ON ta.title_id = ti.title_id
    INNER JOIN sales ON ti.title_id = sales.title_id) AS RoyPerSaleTable
    GROUP BY title_id , au_id) AS r
        INNER JOIN
    titles ti ON r.title_id = ti.title_id
        INNER JOIN
    titleauthor ta ON r.au_id = ta.au_id
ORDER BY TotalProfits DESC;


###############################################################
###############################################################
#####################  BONUS QUESTION  ########################
###############################################################
###############################################################
## Createa permanent table named most_profiting_authors
CREATE TABLE most_profiting_authors SELECT r.au_id,
    (r.RoyalSum + (ta.royaltyper / 100) * (ti.advance)) AS TotalProfits FROM
    RoyPerSaleTableV2 r
        INNER JOIN
    titles ti ON r.title_id = ti.title_id
        INNER JOIN
    titleauthor ta ON r.au_id = ta.au_id
ORDER BY TotalProfits DESC
LIMIT 3;