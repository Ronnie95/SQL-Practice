insert at least 5 rows — use customer_id values from your existing customers (1–5). Make sure at least two customers have more than one order. Paste the result of SELECT * FROM orders; when done.

INSERT INTO orders (customer_id, product, total, order_date)
VALUES
(1, 'Laptop', 1299.99, '2026-07-01'),
(2, 'Monitor', 299.99, '2026-07-02'),
(1, 'Keyboard', 89.99, '2026-07-02'),
(3, 'Mouse', 49.99, '2026-07-03'),
(4, 'Desk Chair', 249.99, '2026-07-03'),
(2, 'Webcam', 119.99, '2026-07-04');