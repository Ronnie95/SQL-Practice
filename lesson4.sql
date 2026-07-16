insert at least 5 rows — use customer_id values from your existing customers (1–5). Make sure at least two customers have more than one order. Paste the result of SELECT * FROM orders; when done.

INSERT INTO orders (customer_id, product, total, order_date)
VALUES
(1, 'Laptop', 1299.99, '2026-07-01'),
(2, 'Monitor', 299.99, '2026-07-02'),
(1, 'Keyboard', 89.99, '2026-07-02'),
(3, 'Mouse', 49.99, '2026-07-03'),
(4, 'Desk Chair', 249.99, '2026-07-03'),
(2, 'Webcam', 119.99, '2026-07-04');


Using an INNER JOIN, show each order with the customers first_name, email, product, and total. Sort by total descending (most expensive first).

SELECT
first_name,
email,
product,
total
FROM customers 
INNER JOIN orders
on customers.customer_id = orders.customer_id
ORDER BY total desc;

Using a LEFT JOIN, show all customers and their orders. Then add a WHERE clause to return only customers who have no orders. (Hint: filter where the order column is NULL.)

SELECT *  FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.order_id
WHERE order_id IS Null ;