Create Database
CREATE DATABASE customer_db;

Create a database with these four tables from scratch. You decide the columns, data types, constraints, and keys:

customers — people who buy from the store
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    city            VARCHAR(50) NOT NULL
);




products — items the store sells (each product has a price and category)
orders — a customer places an order (has a date and status: 'pending', 'shipped', 'delivered', 'cancelled')
order_items — the individual products within an order (an order can contain multiple products)