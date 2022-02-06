-- Make sure that you open up a new tab 
-- You need to have the query in an empty tab
-- Then just press the save drop down button and select "save view" 
-- Name the view "order revenue"

SELECT sum(quantity * list_price * (1 - discount)) as revenue
    , order_id
FROM bike_stores.order_items
GROUP BY order_id;
