-- Analyze Book Performance (calculate total units sold and total revenue per book)
SELECT Books.title,
SUM(Orders.quantity) as Total_Units_Sold,
SUM(Orders.quantity * Books.price) as Total_Revenue
FROM Orders
JOIN Books ON Books.book_id = Orders.book_id
GROUP BY Books.title
ORDER BY Total_Revenue DESC;

-- Inventory Alerts (trigger alerts for books running low on stock)
SELECT title, stock
FROM Books
where stock < 15;

-- Segment Customers Using RFM Analysis(understand top customers and create segments)
WITH customer_metrics AS (
SELECT CUSTOMERS.customer_id, 
CUSTOMERS.name,
MAX(order_date) as last_order,
COUNT(Orders.order_id) as order_frequency,
SUM(Orders.quantity * Books.price) as monetory
FROM Customers 
    JOIN Orders  ON Customers.customer_id = Orders.customer_id
    JOIN Books  ON Orders.book_id = Books.book_id
    GROUP BY Customers.customer_id
)
SELECT *,
       DATEDIFF('2024-07-01', last_order) AS recency_days
FROM customer_metrics;

-- Evaluate Marketing ROI(Compare customer lifetime revenue vs acquisition cost)
WITH customer_spend AS (
SELECT Orders.customer_id,
SUM(Orders.quantity * Books.price) AS total_revenue
FROM Orders
JOIN Books on Orders.book_id = Books.book_id
GROUP BY Orders.customer_id
)
SELECT Customers.customer_id,
Customers.name,
MarketingSpend.spend_amount,
customer_spend.total_revenue,
(customer_spend.total_revenue - MarketingSpend.spend_amount) AS profit
FROM Customers
JOIN MarketingSpend on Customers.customer_id = MarketingSpend.customer_id
JOIN customer_spend ON Customers.customer_id = customer_spend.customer_id;

-- Monthly Sales Trend
SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(quantity) AS total_units_sold,
    SUM(quantity * price) AS total_revenue
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY month
ORDER BY month;

-- Returning Customers
SELECT
Customers.customer_id,
Customers.name,
COUNT(DISTINCT Orders.order_id) AS total_orders
FROM Customers
JOIN Orders on Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id
Having total_orders > 1;

-- Average Order Value (AOV)(revenue is generated per order on average)
SELECT ROUND(SUM(quantity * Books.price) * 1.0 /COUNT(DISTINCT Orders.order_id), 2) AS avg_order_value
FROM Orders
JOIN Books on Orders.book_id = Books.book_id;

-- Books Frequently Bought Together
SELECT o1.book_id AS book_1,
o2.book_id AS book_2,
COUNT(*) AS times_bought_together
FROM Orders o1
JOIN Orders o2
ON o1.customer_id = o2.customer_id AND o1.order_id != o2.order_id
WHERE o1.book_id < o2.book_id
GROUP BY book_1, book_2
ORDER BY times_bought_together DESC
LIMIT 10;

-- Churned Customers(customers who haven’t made a purchase in the last 365 days)
SELECT 
    c.customer_id,
    c.name,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF('2025-07-01', MAX(o.order_date)) AS days_since_last_order
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING days_since_last_order > 365;
