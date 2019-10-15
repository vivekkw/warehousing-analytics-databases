\c star

--- Get the top 3 product types that have proven most profitable

SELECT product_line, SUM(profit) AS profit_prod_type
FROM measures
LEFT JOIN products
USING (product_code)
GROUP BY product_line
ORDER BY profit_prod_type DESC
LIMIT 3;

--- Get the top 3 products by most items sold

SELECT product_name, SUM(quantity_ordered) AS qty_sold
FROM measures
LEFT JOIN products
USING (product_code)
GROUP BY product_name
ORDER BY qty_sold DESC
LIMIT 3;

--- Get the top 3 products by items sold per country of customer for: USA, Spain, Belgium
SELECT country, product_name, qty_country
FROM (
(SELECT country, product_code, SUM(quantity_ordered) AS qty_country
FROM measures
LEFT JOIN customers
USING (customer_number)
WHERE country = 'USA'
GROUP BY country, product_code
ORDER BY qty_country DESC
LIMIT 3)
UNION
(SELECT country, product_code, SUM(quantity_ordered) AS qty_country
FROM measures
LEFT JOIN customers
USING (customer_number)
WHERE country = 'Spain'
GROUP BY country, product_code
ORDER BY qty_country DESC
LIMIT 3)
UNION 
(SELECT country, product_code, SUM(quantity_ordered) AS qty_country
FROM measures
LEFT JOIN customers
USING (customer_number)
WHERE country = 'Belgium'
GROUP BY country, product_code
ORDER BY qty_country DESC
LIMIT 3)
) AS f
LEFT JOIN products
USING (product_code)
ORDER BY country;


--- Get the most profitable day of the week
SELECT order_day, SUM(profit) AS total_profit
FROM measures
LEFT JOIN orders
USING (order_number)
GROUP BY order_day
ORDER BY total_profit DESC
LIMIT 1;

--- Get the top 3 city-quarters with the highest average profit margin in their sales
SELECT city, order_quarter AS quarter, (SUM(profit)/SUM(sales)) AS average_profit_margin
FROM measures
LEFT JOIN orders
USING (order_number)
LEFT JOIN employees
USING (sales_rep_employee_number)
GROUP BY city, order_quarter
ORDER BY average_profit_margin DESC
LIMIT 3;

--- List the employees who have sold more goods (in $ amount) than the average employee.

-- Define average employee as the employee with median sales
SELECT last_name, first_name, total_sales FROM (
SELECT sales_rep_employee_number, SUM(sales) AS total_sales
FROM measures 
GROUP BY sales_rep_employee_number
ORDER BY total_sales DESC
LIMIT (SELECT FLOOR(COUNT(DISTINCT (sales_rep_employee_number))/2) FROM measures)
) AS f
LEFT JOIN employees
USING (sales_rep_employee_number);

-- Define average employee by the average sales made
SELECT last_name, first_name, total_sales FROM (
SELECT sales_rep_employee_number, SUM(sales) AS total_sales
FROM measures 
GROUP BY sales_rep_employee_number) AS s
LEFT JOIN employees
USING (sales_rep_employee_number)
WHERE s.total_sales::NUMERIC > (
    SELECT (SUM(sales)/COUNT(DISTINCT sales_rep_employee_number))::NUMERIC AS average_sales
    FROM measures
);


--- List all the orders where the sales amount in the order is in the top 10% of all order sales amounts (BONUS: Add the employee number)

SELECT DISTINCT order_number, sales_amount, sales_rep_employee_number FROM (
SELECT order_number, SUM(sales) AS sales_amount
FROM measures
GROUP BY order_number) AS s
LEFT JOIN measures
USING (order_number)
WHERE s.sales_amount::NUMERIC > (
    SELECT PERCENTILE_DISC(0.9) WITHIN GROUP (ORDER BY sales_amount)::NUMERIC 
    FROM (SELECT order_number, SUM(sales) AS sales_amount
            FROM measures
            GROUP BY order_number
    ) AS f
);
