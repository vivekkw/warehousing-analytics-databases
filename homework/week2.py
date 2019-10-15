#cat tables.sql | docker run --net host -i postgres psql --host 0.0.0.0 --user postgres

import pandas as pd
import psycopg2

conn = psycopg2.connect("dbname=week1 user=postgres host=localhost")
cursor = conn.cursor()

cursor.execute("SELECT product_code, product_name, product_line, product_scale, product_vendor, quantity_in_stock, buy_price, _m_s_r_p FROM product_info")
products = cursor.fetchall() 

cursor.execute("SELECT customer_number, customer_name, city, state, country, credit_limit FROM customer_info")
customers = cursor.fetchall()

cursor.execute("SELECT employee_number, last_name, first_name, office_code, city, country FROM employee_info INNER JOIN office_info USING (office_code)")
employees = cursor.fetchall()

cursor.execute("SELECT order_number, required_date, status, order_date, TO_CHAR(order_date, 'day') AS order_day, EXTRACT(year FROM order_date) AS order_year, EXTRACT(quarter FROM order_date) AS order_quarter FROM order_info")
orders = cursor.fetchall()

cursor.execute("SELECT order_number, order_line_number, product_code, quantity_ordered, price_each, customer_number, sales_rep_employee_number, (quantity_ordered * price_each) AS sales, (quantity_ordered * buy_price) AS cost, (quantity_ordered * price_each-quantity_ordered * buy_price) AS profit FROM order_items AS o INNER JOIN order_info AS oi USING (order_number) INNER JOIN customer_info USING (customer_number) INNER JOIN product_info USING (product_code)")
measures = cursor.fetchall()

conn.commit()
cursor.close()
conn.close()

conn = psycopg2.connect("dbname=star user=postgres host=localhost")
cursor = conn.cursor()

for row in products:
       cursor.execute("INSERT INTO products (product_code, product_name, product_line, product_scale, product_vendor, quantity_in_stock, buy_price, _m_s_r_p) VALUES(%s, %s, %s, %s, %s, %s, %s, %s)", row)
        
for row in customers:
       cursor.execute("INSERT INTO customers (customer_number, customer_name, city, state, country, credit_limit) VALUES(%s, %s, %s, %s, %s, %s)", row)
        
for row in employees:
       cursor.execute("INSERT INTO employees (sales_rep_employee_number, last_name, first_name, office_code, city, country) VALUES(%s, %s, %s, %s, %s, %s)", row)
               
for row in orders:
       cursor.execute("INSERT INTO orders (order_number, required_date, status, order_date, order_day, order_year, order_quarter) VALUES(%s, %s, %s, %s, %s, %s, %s)", row)
               
for row in measures:
       cursor.execute("INSERT INTO measures (order_number, order_line_number, product_code, quantity_ordered, price_each, customer_number, sales_rep_employee_number, sales, cost, profit) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", row)

conn.commit()
cursor.close()
conn.close()