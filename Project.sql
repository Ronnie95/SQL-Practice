Create Database
CREATE DATABASE customer_db;

Create a database with these four tables from scratch. You decide the columns, data types, constraints, and keys:

customers — people who buy from the store
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL
);

products — items the store sells (each product has a price and category)
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

orders — a customer places an order (has a date and status: 'pending', 'shipped', 'delivered', 'cancelled')
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    order_status VARCHAR(20)
        CHECK (
                order_status IN (
                    'pending',
                    'shipped',
                    'delivered',
                    'cancelled'
                )
            )

);

order_items — the individual products within an order (an order can contain multiple products)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);