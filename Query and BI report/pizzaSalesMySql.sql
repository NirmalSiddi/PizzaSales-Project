-- SELECT * FROM pizzadb.pizza_sales;

-- ALTER TABLE pizzadb.pizza_sales
-- MODIFY order_date DATE;

-- ALTER TABLE pizzadb.pizza_sales
-- MODIFY order_time TIME NOT NULL;

-- ALTER TABLE pizza_sales ADD COLUMN new_order_date DATE;

-- UPDATE pizza_sales
-- SET new_order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
-- WHERE STR_TO_DATE(order_date, '%d-%m-%Y') IS NOT NULL;

-- SELECT order_date, new_order_date
-- FROM pizza_sales
-- WHERE new_order_date IS NULL;

-- ALTER TABLE pizza_sales DROP COLUMN order_date;

-- ALTER TABLE pizza_sales CHANGE COLUMN new_order_date order_date DATE;

-- SELECT DATE(order_date) AS order_day, COUNT(*) AS total_orders
-- FROM pizza_sales
-- GROUP BY DATE(order_date);

-- ALTER TABLE pizza_sales ADD COLUMN new_order_time TIME;
-- UPDATE pizza_sales
-- SET new_order_time = 
--     TIME_FORMAT(
--         STR_TO_DATE(order_time, '%h.%i.%s %p'), '%H:%i:%s'
--     )
-- WHERE STR_TO_DATE(order_time, '%h.%i.%s %p') IS NOT NULL;

-- SELECT order_time, new_order_time
-- FROM pizza_sales
-- WHERE new_order_time IS NULL;

-- ALTER TABLE pizza_sales DROP COLUMN order_time;

-- ALTER TABLE pizza_sales CHANGE COLUMN new_order_time order_time TIME NOT NULL;

########################################################################################

/*
	Recommended Analysis
How many customers do we have each day? Are there any peak hours?
How many pizzas are typically in order? Do we have any bestsellers?
How much money did we make this year? Can we identify any seasonality in the sales?
Are there any pizzas we should take off the menu, or any promotions we could leverage?

*/

SELECT * FROM pizza_sales;

# How many customers do we have each day? 

SELECT 
    DATE(order_date) AS per_day,
    COUNT(DISTINCT (order_id)) AS orders
FROM
    pizzadb.pizza_sales
GROUP BY order_date;


# Are there any peak hours?

SELECT 
    HOUR(order_time) AS peak_hour, COUNT(*) AS orders
FROM
    pizzadb.pizza_sales
GROUP BY peak_hour
ORDER BY orders DESC;

# How many pizzas are typically in order?

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales;

# Do we have any bestsellers?

SELECT 
    pizza_name, SUM(quantity) AS times_ordered
FROM
    pizzadb.pizza_sales
GROUP BY pizza_name
ORDER BY times_ordered DESC;

# How much money did we make this year? 

SELECT 
    SUM(total_price) AS yearly_revenue
FROM
    pizzadb.pizza_sales;

#Can we identify any seasonality in the sales?

SELECT 
    MONTHNAME(order_date) AS months, ROUND(SUM(total_price), 2) AS monthly_revenue
FROM
    pizzadb.pizza_sales
GROUP BY months
ORDER BY monthly_revenue DESC;

# Are there any pizzas we should take off the menu, 

SELECT 
    pizza_name, SUM(quantity) AS sold
FROM
    pizzadb.pizza_sales
GROUP BY pizza_name
ORDER BY sold ASC;

#any promotions we could leverage?

SELECT
	pizza_category, ROUND(SUM(total_price), 2) AS total
FROM
	pizzadb.pizza_sales
GROUP BY pizza_category
ORDER BY total DESC;