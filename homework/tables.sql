CREATE DATABASE star;
\c star

CREATE TABLE products (
product_code VARCHAR PRIMARY KEY,
product_name VARCHAR,
product_line VARCHAR,
product_scale VARCHAR,
product_vendor VARCHAR,
quantity_in_stock INTEGER,
buy_price MONEY,
_m_s_r_p MONEY
);
--removed product_description
--removed html_description

CREATE TABLE customers(
customer_number INTEGER PRIMARY KEY,
customer_name VARCHAR,
city VARCHAR,
state VARCHAR,
country VARCHAR, 
credit_limit MONEY
);
--removed contact_last_name and contact_first_name
--removed customer_location

CREATE TABLE employees(
sales_rep_employee_number INTEGER PRIMARY KEY,
last_name VARCHAR,
first_name VARCHAR,
office_code INTEGER,
city VARCHAR,
country VARCHAR
);
--removed state: all in different states and some do not have states; analysis by city suffices
--removed office_location: city/country is sufficient for analysis

CREATE TABLE orders(
order_number INTEGER PRIMARY KEY,
required_date DATE,
status VARCHAR,
order_date DATE,
order_day VARCHAR,
order_year INTEGER,
order_quarter INTEGER
);
--removed comments
--added order_day

CREATE TABLE measures (
order_number INTEGER REFERENCES orders(order_number),
order_line_number INTEGER,
product_code VARCHAR REFERENCES products(product_code),
customer_number INTEGER REFERENCES customers(customer_number),
sales_rep_employee_number INTEGER REFERENCES employees(sales_rep_employee_number),
quantity_ordered INTEGER,
price_each MONEY,
sales MONEY,
cost MONEY,
profit MONEY
);
--added aggregations for sales, cost, profit
