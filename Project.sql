--Create Database
CREATE DATABASE customer_db;

--Create a database with these four tables from scratch. You decide the columns, data types, constraints, and keys:

--customers — people who buy from the store

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL
);
--products — items the store sells (each product has a price and category)

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

--orders — a customer places an order (has a date and status: 'pending', 'shipped', 'delivered', 'cancelled')

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(20) NOT NULL CHECK (
        order_status IN (
            'pending',
            'shipped',
            'delivered',
            'cancelled'
        )
    ),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

--order_items — the individual products within an order (an order can contain multiple products)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

Insert enough data to make the queries interesting: at least 5 customers, 6 products across at least 2 categories, 8 orders with varying statuses, and at least 12 order items.

-- Customers
INSERT INTO customers (first_name, last_name, email, city)
VALUES
('John', 'Smith', 'john.smith@email.com', 'Chicago'),
('Sarah', 'Jones', 'sarah.jones@email.com', 'Cleveland'),
('Mike', 'Brown', 'mike.brown@email.com', 'Atlanta'),
('Emily', 'Davis', 'emily.davis@email.com', 'Dallas'),
('David', 'Wilson', 'david.wilson@email.com', 'Phoenix');


-- Products
INSERT INTO products (product_name, category, price)
VALUES
('Laptop', 'Electronics', 1200.00),
('Mouse', 'Electronics', 35.00),
('Keyboard', 'Electronics', 80.00),
('Office Chair', 'Furniture', 250.00),
('Desk', 'Furniture', 450.00),
('Bookshelf', 'Furniture', 180.00);


-- Orders
INSERT INTO orders (customer_id, order_date, order_status)
VALUES
(1, '2026-01-05', 'delivered'),
(2, '2026-01-10', 'shipped'),
(3, '2026-01-15', 'pending'),
(1, '2026-02-01', 'cancelled'),
(5, '2026-02-10', 'delivered'),
(2, '2026-02-15', 'shipped'),
(4, '2026-03-01', 'delivered'),
(3, '2026-03-05', 'pending');


-- Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1200.00),
(1, 2, 2, 35.00),
(2, 4, 1, 250.00),
(2, 5, 1, 450.00),
(3, 6, 2, 180.00),
(4, 3, 1, 80.00),
(5, 1, 1, 1200.00),
(5, 4, 2, 250.00),
(6, 2, 3, 35.00),
(7, 5, 1, 450.00),
(8, 3, 2, 80.00),
(8, 6, 1, 180.00);


--1.Which customers have placed more than one order?
SELECT c.first_name, c.last_name, c.customer_id, o.order_status, o.order_id
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;

--2.What is the total revenue per product category?
SELECT p.category, SUM(price) AS total_revenue
FROM products p
GROUP BY p.category;

--3.What are the top 3 best-selling products by total quantity sold?
SELECT product_name, SUM(price) AS best_selling
FROM products
GROUP BY product_name
ORDER BY best_selling DESC
LIMIT 3;

--4.Which orders have been cancelled? Show the customer name and order date.
SELECT o.order_status, o.order_date, c.first_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'cancelled';


--5.What is the average order value across all orders?
SELECT AVG(unit_price) AS avg_order_value
FROM order_items;

--6.Which customer has spent the most money overall?

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)

SELECT
    first_name,
    last_name,
    total_spent
FROM customer_totals
ORDER BY total_spent DESC
LIMIT 1;
--7.For each customer, show their most recent order date.

SELECT c.first_name, c.last_name, MAX(o.order_date) AS recent_order
FROM customers c 
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY recent_order DESC;


--8.Which products have never been ordered?
SELECT p.product_name, oi.quantity
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


--9.Show a running total of revenue ordered by date.
SELECT o.order_date, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY order_date
ORDER BY o.order_date DESC;

--10.Rank customers by total spend using DENSE_RANK.
