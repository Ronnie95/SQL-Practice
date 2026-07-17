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

Write a query that answers: "What is the most expensive order DaRon has ever placed?" Use a JOIN to get there — dont hardcode customer_id = 1.

SELECT first_name, product, total from customers
JOIN orders
ON customers.customer_id = orders.customer_id
WHERE first_name = 'DaRon'
ORDER by total desc
limit 1;

How many orders has each customer placed? Show first_name and num_orders, sorted by num_orders descending.

SELECT first_name, COUNT(*) as num_orders
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id
GROUP BY first_name
ORDER BY num_orders desc;


What is the total revenue and average order value per city? Show city, total_revenue, and avg_order_value. Round the average to 2 decimal places using ROUND(AVG(o.total), 2).

SELECT city, SUM(total) AS total_revenue,
ROUND(AVG(total), 2) AS avg_order_value
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id
GROUP BY city;



Which customers have placed more than 1 order? Use HAVING.

SELECT  first_name, COUNT(*) AS more
FROM orders
JOIN customers
on orders.customer_id = customers.customer_id
GROUP BY first_name
HAVING COUNT(*) > 1;



Stretch: Show each customers first_name, total spent, and the percentage of total revenue they represent. (Hint: youll need SUM(total) across all orders as the denominator — you can get that with a subquery: (SELECT SUM(total) FROM

SELECT  first_name, COUNT(*) AS more, SUM(total) AS total_spent
FROM orders
JOIN customers
on orders.customer_id = customers.customer_id
GROUP BY first_name
HAVING COUNT(*) > 1;

SELECT
    c.first_name,
    SUM(o.total) AS total_spent,
    ROUND(SUM(o.total) / (SELECT SUM(total) FROM orders) * 100, 2) AS pct_of_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name
ORDER BY pct_of_revenue DESC;


Using a subquery in WHERE, find all orders where the total is above the average. Show product, total, and the customers first_name.

SELECT c.first_name, o.product, o.total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total > (SELECT AVG(total) FROM orders);

Rewrite exercise 1 using a CTE instead of a subquery. The result should be identical.

WITH order_details AS (
    SELECT c.first_name, o.product, o.total
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT first_name, product, total
FROM order_details
WHERE total > (SELECT AVG(total) FROM orders);

Using a CTE, find the city with the highest total revenue. Show city and total_revenue.

WITH CTE_lesson AS (
    SELECT SUM(total) AS total_revenue, city
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY city
)
SELECT city, total_revenue
FROM CTE_lesson
ORDER BY total_revenue desc
LIMIT 1;

Stretch: Write a CTE that calculates each customers total spent, then in the outer query show only customers who spent more than the average customer spending. (Hint: youll need AVG(total_spent) in the outer query — or a second CTE.)

WITH CTE_lesson AS (
    SELECT SUM(total) AS total_spent, first_name
    FROM orders o
    JOIN customers c 
    ON o.customer_id = c.customer_id
    GROUP BY first_name 
)
SELECT AVG(total_spent) AS average_spend, first_name
FROM CTE_lesson
WHERE first_name > average_spend;

WITH customer_totals AS (
    SELECT
        c.first_name,
        SUM(o.total) AS total_spent
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.first_name
)
SELECT
    first_name,
    total_spent
FROM customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_totals
);

Rank all orders by total (highest first) using DENSE_RANK. Show first_name, product, total, and rank. What rank is DaRons Keyboard?

SELECT c.first_name, o.product, o.total,
    DENSE_RANK() OVER (ORDER BY o.total DESC) AS dense_rank 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;


For each customer, number their orders chronologically using ROW_NUMBER partitioned by customer. Show first_name, product, order_date, and order_num.

SELECT c.first_name, o.product, o.order_date,
    ROW_NUMBER() OVER (PARTITION BY c.first_name) AS customers
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

SELECT c.first_name, o.product, o.order_date,
    ROW_NUMBER() OVER (PARTITION BY c.first_name ORDER BY o.order_date) AS order_num
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

Using LAG, show each order alongside the previous order total for that customer. Add a column called change that calculates the difference between the current total and the previous total. (Hint: total - LAG(total) OVER (...))

SELECT
c.first_name,
o.product,
LAG(o.total) OVER (PARTITION BY c.first_name) AS change
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT
    c.first_name,
    o.order_date,
    o.total,
    LAG(o.total) OVER (PARTITION BY c.first_name ORDER BY o.order_date) AS prev_order,
    o.total - LAG(o.total) OVER (PARTITION BY c.first_name ORDER BY o.order_date) AS change
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

Stretch: Find each customers single most expensive order using RANK. Use a CTE to rank orders per customer, then in the outer query filter to only rank = 1.

WITH customer_orders AS (

    SELECT c.first_name, o.product, o.total,
        RANK() OVER (ORDER BY o.total DESC)
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_orders
LIMIT 1

WITH customer_orders AS (
    SELECT
        c.first_name,
        o.product,
        o.total,
        RANK() OVER (PARTITION BY c.first_name ORDER BY o.total DESC) AS rnk
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT first_name, product, total
FROM customer_orders
WHERE rnk = 1;