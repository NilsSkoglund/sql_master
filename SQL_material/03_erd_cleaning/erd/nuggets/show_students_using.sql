-- Show em USING(xxx), so much nicer

-------------------------------------------------------------------------------
-- EXCERCISE 2:
-- How many employees are working in each store?
-------------------------------------------------------------------------------

-- join key = store_id

-- ON 
SELECT stores.store_id
    ,COUNT(staff_id) as emp_count
FROM bike_stores.stores AS stores
INNER JOIN bike_stores.staff AS staff 
    ON stores.store_id = staff.store_id -- with ON
GROUP BY stores.store_id;


-- USING
SELECT stores.store_id
    ,COUNT(staff_id) as emp_count
FROM bike_stores.stores AS stores
INNER JOIN bike_stores.staff AS staff 
    USING(store_id) -- with USING
GROUP BY stores.store_id;