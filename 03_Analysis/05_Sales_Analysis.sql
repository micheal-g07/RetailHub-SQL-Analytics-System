/*
=========================================================
Project     : RetailHub Sales Analytics System
File        : 05_Sales_Analysis.sql
Author      : Micheal
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Sales Analysis
Version     : 1.0

=========================================================

TABLE OF CONTENTS

1. Overall KPIs
2. Revenue Analysis
3. Order Analysis
4. Product Analysis
5. Store Performance
6. Customer Analysis
7. Payment Analysis
8. Return Analysis

Purpose:
	Generates business KPIs and analytical reports
	covering sales, revenue, products, stores,
	customers, payments, and returns.
=========================================================
*/

USE RetailHub;

/*=========================================================
SECTION 1
OVERALL SALES KPI

Business Objective:
	Analyze overall business performance using key metrics 
    such as revenue, orders, customers, and products 
    to measure business health and growth.
=========================================================*/

-- =====================================================
-- KPI 01 : Total Revenue
-- Business Insight:
-- Shows the total sales generated and provides a quick
-- view of overall business performance.
-- =====================================================
SELECT 
	SUM(Net_Amount) AS Completed_Net_Revenue
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 02 : Gross Revenue
-- Business Insight:
-- Measures total sales before returns and discounts,
-- helping evaluate overall sales performance.
-- =====================================================
SELECT 
	SUM(Gross_Amount) AS Gross_Revenue
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 03 : Discount Given
-- Business Insight:
-- Tracks the value of discounts offered to understand
-- their impact on sales and profitability.
-- =====================================================
SELECT 
	SUM(Discount_Amount) AS Total_Discount_Given
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 04 : Tax Collected
-- Business Insight:
-- Measures the total tax collected from customer orders
-- for financial reporting purposes.
-- =====================================================
SELECT 
	SUM(Tax_Amount) AS Total_Tax_Collected
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 05 : Completed Revenue
-- Business Insight:
-- Shows revenue earned from successfully completed orders,
-- excluding cancelled or returned transactions.
-- =====================================================
SELECT
	SUM(Net_Amount) AS Completed_Revenue
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 06 : Revenue Per Customer
-- Business Insight:
-- Indicates how much revenue, on average, each customer
-- contributes to the business.
-- =====================================================
SELECT
	ROUND(
		SUM(CASE WHEN Order_Status = 'Completed' THEN Net_Amount ELSE 0 END) / COUNT(DISTINCT Customer_ID), 2
    ) AS Revenue_Per_Customer
FROM Orders;

-- =====================================================
-- KPI 07 : Total Orders
-- Business Insight:
-- Counts all customer orders to measure overall sales
-- activity and demand.
-- =====================================================
SELECT 
	COUNT(*) AS Total_Orders
FROM Orders;

-- =====================================================
-- KPI 08 : Completed Orders
-- Business Insight:
-- Tracks successfully fulfilled orders to monitor
-- operational performance.
-- =====================================================
SELECT
	COUNT(*) AS Completed_Orders
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 09 : Cancelled Orders
-- Business Insight:
-- Measures cancelled orders to identify potential issues
-- in the ordering process.
-- =====================================================
SELECT
	COUNT(*) AS Cancelled_Orders
FROM Orders
WHERE Order_Status = 'Cancelled';

-- =====================================================
-- KPI 10 : Returned Orders
-- Business Insight:
-- Tracks returned orders to monitor customer satisfaction
-- and product quality.
-- =====================================================
SELECT
	COUNT(*) AS Returned_Orders
FROM Orders
WHERE Order_Status = 'Returned';

-- =====================================================
-- KPI 11 : Pending Orders
-- Business Insight:
-- Shows orders that are still awaiting completion or
-- fulfillment.
-- =====================================================
SELECT
	COUNT(*) AS Pending_Orders
FROM Orders
WHERE Order_Status = 'Pending';

-- =====================================================
-- KPI 12 : Average Order Value (AOV)
-- Business Insight:
-- Measures the average amount customers spend per order,
-- helping evaluate purchasing behavior.
-- =====================================================
SELECT 
	ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed';

-- =====================================================
-- KPI 13 : Total Customers
-- Business Insight:
-- Counts unique customers who have placed orders during
-- the selected period.
-- =====================================================
SELECT 
	COUNT(*) AS Total_Customers
FROM Customers;

-- =====================================================
-- KPI 14 : Total Unique Products Sold
-- Business Insight:
-- Shows how many different products were purchased,
-- reflecting product variety.
-- =====================================================
SELECT
	COUNT(DISTINCT Product_ID) AS Unique_Sold_Products
FROM Order_Items;

-- =====================================================
-- KPI 15 : Total Quantity Sold
-- Business Insight:
-- Measures the total number of product units sold across
-- all orders.
-- =====================================================
SELECT
	SUM(Quantity) AS Total_Sold_Quantity
FROM Order_Items;

-- =====================================================
-- KPI 16 : Average Quantity Per Order
-- Business Insight:
-- Shows the average number of items included in each
-- customer order.
-- =====================================================
SELECT
	ROUND(AVG(Item_Count), 2) AS Average_Quantity_Per_Order
FROM (
	SELECT 
		Order_ID,
		SUM(Quantity) AS Item_Count
	FROM Order_Items
	GROUP BY Order_ID
) t;

-- =====================================================
-- KPI 17 : Total Return Items
-- Business Insight:
-- Tracks the number of products returned by customers
-- over the analysis period.
-- =====================================================
SELECT 
	COUNT(*) AS Total_Returned_Items
FROM Returns;

-- =====================================================
-- KPI 18 : Order Return Rate (%)
-- Business Insight:
-- Measures the percentage of orders that were returned,
-- helping evaluate customer satisfaction.
-- =====================================================
SELECT 
	ROUND(
		COUNT(*) * 100 / 
        (SELECT COUNT(*) FROM Orders), 2
    ) AS Order_Return_Rate_Percentage
FROM Orders
WHERE Order_Status = 'Returned';

-- =====================================================
-- KPI 19 : Item Return Rate (%)
-- Business Insight:
-- Shows the percentage of sold items that were returned
-- by customers.
-- =====================================================
SELECT 
	ROUND(
		COUNT(*) * 100 / 
        (SELECT COUNT(*) FROM Order_Items), 2
    ) AS Item_Return_Rate_Percentage
FROM Returns;

-- =====================================================
-- KPI 20 : Revenue Return Rate (%)
-- Business Insight:
-- Measures how much revenue was lost due to returned
-- orders.
-- =====================================================
SELECT
	ROUND(
		SUM(Refund_Amount) * 100 / 
        (SELECT SUM(Total_Price) FROM Order_Items), 2
    ) AS Revenue_Return_Rate_Percentage
FROM Returns;

-- =====================================================
-- KPI 21 : Orders Summary
-- Business Insight:
-- Provides a quick overview of key order-related metrics
-- in one place.
-- =====================================================
SELECT
	COUNT(*) AS Total_Orders,
    SUM(Order_Status = 'Completed') AS Completed_Orders,
    SUM(Order_Status = 'Cancelled') AS Cancelled_Orders,
    SUM(Order_Status = 'Pending') AS Pending_Orders,
    SUM(Order_Status = 'Returned') AS Returned_Orders,
    SUM(Net_Amount) AS Total_Revenue,
    ROUND(AVG(Net_Amount), 2) AS Average_Orders_Value_AOV
FROM Orders;

-- =====================================================
-- KPI 22 : Order Status Distribution (%)
-- Business Insight:
-- Shows how orders are distributed across different
-- order statuses.
-- =====================================================
SELECT 
	ROUND(
		SUM(Order_Status = 'Completed') * 100 / NULLIF (COUNT(*), 0), 2
    ) AS Completed_Order_Rate_Percentage,
    ROUND(
		SUM(Order_Status = 'Cancelled') * 100 / NULLIF (COUNT(*), 0), 2
    ) AS Cancelled_Order_Rate_Percentage,
    ROUND(
		SUM(Order_Status = 'Pending') * 100 / NULLIF (COUNT(*), 0), 2
    ) AS Pending_Order_Rate_Percentage,
    ROUND(
		SUM(Order_Status = 'Returned') * 100 / NULLIF (COUNT(*), 0), 2
    ) AS Returned_Order_Rate_Percentage
FROM Orders;

-- =====================================================
-- KPI 23 : Orders Net Revenue Distribution (%)
-- Business Insight:
-- Shows how net revenue is distributed across different
-- order statuses, highlighting their contribution to
-- overall business revenue.
-- =====================================================
SELECT 
	ROUND(
		SUM(CASE WHEN Order_Status = 'Completed' THEN Net_Amount END) * 100 / NULLIF (SUM(Net_Amount), 0), 2
    ) AS Completed_Revenue_Rate_Percentage,
    ROUND(
		SUM(CASE WHEN Order_Status = 'Cancelled' THEN Net_Amount END) * 100 / NULLIF (SUM(Net_Amount), 0), 2
    ) AS Cancelled_Revenue_Rate_Percentage,
    ROUND(
		SUM(CASE WHEN Order_Status = 'Pending' THEN Net_Amount END) * 100 / NULLIF (SUM(Net_Amount), 0), 2
    ) AS Pending_Revenue_Rate_Percentage,
    ROUND(
		SUM(CASE WHEN Order_Status = 'Returned' THEN Net_Amount END) * 100 / NULLIF (SUM(Net_Amount), 0), 2
    ) AS Returned_Revenue_Rate_Percentage
FROM Orders;

/*
=========================================================
End of OVERALL SALES KPIs

Total KPIs Implemented : 23

Sections Completed
✔ OVERALL SALES KPIs

Next:
REVENUE ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 2
REVENUE ANALYSIS

Business Objective:
	Evaluate revenue trends, identify top revenue 
    contributors, and measure overall sales performance.
=========================================================*/

-- =====================================================
-- KPI 01 : Revenue by Month
-- Business Insight:
-- Shows monthly revenue trends and helps identify seasonal
-- patterns and business growth over time.
-- =====================================================
SELECT 
        YEAR(Order_Date) AS Year,
        MONTH(Order_Date) AS Month_No,
        MONTHNAME(Order_Date) AS Month,
        COUNT(Order_ID) AS Orders,
        ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
        ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

-- =====================================================
-- KPI 02 : Revenue by Year
-- Business Insight:
-- Compares annual revenue to measure long-term business
-- growth and overall performance.
-- =====================================================
SELECT 
	YEAR(Order_Date) AS Year,
    COUNT(Order_ID) AS Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

-- =====================================================
-- KPI 03 : Revenue by Quarter
-- Business Insight:
-- Breaks revenue into quarterly periods to evaluate
-- performance throughout the financial year.
-- =====================================================
SELECT 
	YEAR(Order_Date) AS Year,
    CONCAT('Q', QUARTER(Order_Date)) AS Quarter,
    COUNT(Order_ID) AS Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY YEAR(Order_Date), CONCAT('Q', QUARTER(Order_Date))
ORDER BY YEAR(Order_Date), CONCAT('Q', QUARTER(Order_Date));

-- =====================================================
-- KPI 04 : Revenue by Weekday
-- Business Insight:
-- Shows which days of the week generate the highest sales,
-- helping optimize promotions and staffing.
-- =====================================================
SELECT 
	DAYNAME(Order_Date) AS Weekday,
    COUNT(Order_ID) AS Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY DAYNAME(Order_Date), WEEKDAY(Order_Date)
ORDER BY WEEKDAY(Order_Date);

-- =====================================================
-- KPI 05 : Revenue by Hour
-- Business Insight:
-- Identifies peak sales hours to improve staffing,
-- customer service, and promotional timing.
-- =====================================================
SELECT 
	HOUR(Order_Date) AS Hour,
    COUNT(*) AS Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY HOUR(Order_Date)
ORDER BY Hour;

-- =====================================================
-- KPI 06 : Month-over-Month Growth (%)
-- Business Insight:
-- Measures monthly revenue growth to track business
-- performance and identify emerging trends.
-- =====================================================
WITH Monthly_Metrics AS (
	SELECT 
		YEAR(Order_Date) AS Year,
        MONTH(Order_Date) AS Month_No,
        MONTHNAME(Order_Date) AS Month,
        ROUND(SUM(Net_Amount), 2) AS Completed_Revenue
    FROM Orders
    WHERE Order_Status = 'Completed'
    GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
)
SELECT 
	Year,
    Month_No,
    Month,
    Completed_Revenue,
    LAG(Completed_Revenue) OVER(
		ORDER BY Year, Month_no
    ) AS Previous_Month_Revenue,
    ROUND(
		(Completed_Revenue - LAG(Completed_Revenue) OVER(ORDER BY Year, Month_no)) /
        LAG(Completed_Revenue) OVER(ORDER BY Year, Month_no) * 100, 2
    ) AS MoM_Growth_Ptc
FROM Monthly_Metrics;

-- =====================================================
-- KPI 07 : Revenue by Store
-- Business Insight:
-- Compares revenue across stores to identify top-performing
-- and underperforming locations.
-- =====================================================
SELECT 
    s.Store_ID,
    s.Store_Name,
    COUNT(DISTINCT o.Order_ID) AS Orders,
    ROUND(SUM(o.Net_Amount), 2) AS Revenue_By_Stores,
    ROUND(AVG(o.Net_Amount), 2) AS Average_Revenue_Per_Store,
    ROUND(
        (SUM(o.Net_Amount) / 
        (SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2
    ) AS Net_Revenue_Share_Percentage
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Revenue_By_Stores DESC;

-- =====================================================
-- KPI 08 : Revenue by Category
-- Business Insight:
-- Shows which product categories contribute the most
-- to overall revenue.
-- =====================================================
WITH OrderLine AS (
    SELECT 
        oi.Order_ID,
        p.Category_ID,
        (oi.Total_Price / o.Gross_Amount) AS Item_Revenue_Share,
        o.Net_Amount
    FROM Order_Items oi
    JOIN Products p ON oi.Product_ID = p.Product_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT 
    cat.Category_ID,
    cat.Category_Name,
    COUNT(DISTINCT ol.Order_ID) AS Ordered_Units,
    ROUND(SUM(ol.Item_Revenue_Share * ol.Net_Amount), 2) AS Revenue_by_Categories,
    ROUND(AVG(ol.Item_Revenue_Share * ol.Net_Amount), 2) AS Average_Revenue_Per_Order_Line,
    ROUND(
		(SUM(ol.Item_Revenue_Share * ol.Net_Amount) / 
        (SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2
    ) AS Net_Revenue_Share_Percentage
FROM OrderLine ol
JOIN Categories cat ON ol.Category_ID = cat.Category_ID
GROUP BY cat.Category_ID, cat.Category_Name
ORDER BY Revenue_by_Categories DESC;

-- =====================================================
-- KPI 09 : Revenue by Product
-- Business Insight:
-- Measures revenue generated by each product to identify
-- top-selling and low-performing items.
-- =====================================================
WITH ProductLines AS (
	SELECT 
		oi.Product_ID,
        o.Order_ID,
        (oi.Total_Price / o.Gross_Amount) AS Product_Revenue_Share,
        o.Net_Amount
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT 
	p.Product_ID,
    p.Product_Name,
    COUNT(DISTINCT pl.Order_ID) AS Orders,
    ROUND(SUM(pl.Product_Revenue_Share * pl.Net_Amount), 2) AS Revenue_by_Product,
    ROUND(AVG(pl.Product_Revenue_Share * pl.Net_Amount), 2) AS Average_Revenue_Per_Product,
    ROUND(
		(SUM(pl.Product_Revenue_Share * pl.Net_Amount) /
        (SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2
    ) AS Net_Revenue_Share_Percentage
FROM Products p
JOIN ProductLines pl ON p.Product_ID = pl.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue_by_Product DESC;

-- =====================================================
-- KPI 10 : Revenue by City
-- Business Insight:
-- Compares revenue across cities to understand regional
-- sales performance.
-- =====================================================
SELECT 
	s.City,
    COUNT(o.Order_ID) AS Orders,
    ROUND(SUM(o.Net_Amount)) AS Revenue_by_City,
    ROUND(AVG(o.Net_Amount)) AS Average_Revenue_per_City
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.City
ORDER BY Revenue_by_City DESC;

-- =====================================================
-- KPI 11 : Revenue by Customer
-- Business Insight:
-- Identifies customers who contribute the most revenue,
-- helping recognize high-value customers.
-- =====================================================
SELECT 
	c.Customer_ID,
	CONCAT(c.First_Name,' ',c.Last_Name) AS Customer_Name,
    COUNT(o.Order_ID) AS Orders,
    ROUND(SUM(o.Net_Amount)) AS Revenue_by_Customer,
    ROUND(AVG(o.Net_Amount)) AS Average_Revenue_per_Customer
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID, CONCAT(c.First_Name,' ',c.Last_Name)
ORDER BY Revenue_by_Customer DESC;

-- =====================================================
-- KPI 12 : Revenue by Employee
-- Business Insight:
-- Evaluates employee sales performance based on the
-- revenue they generate.
-- =====================================================
SELECT 
	e.Employee_ID,
	CONCAT(e.First_Name,' ',e.Last_Name) AS Employee_Name,
    COUNT(o.Order_ID) AS Orders,
    ROUND(SUM(o.Net_Amount)) AS Revenue_by_Employee,
    ROUND(AVG(o.Net_Amount)) AS Average_Revenue_per_Employee
FROM Employees e
JOIN Orders o ON e.Employee_ID = o.Employee_ID
WHERE o.Order_Status = 'Completed'
GROUP BY e.Employee_ID, CONCAT(e.First_Name,' ',e.Last_Name)
ORDER BY Revenue_by_Employee DESC;

-- =====================================================
-- KPI 13 : Top 10 Products
-- Business Insight:
-- Highlights the highest revenue-generating products to
-- identify the business's best performers.
-- =====================================================
WITH ProductLines AS (
	SELECT 
		oi.Product_ID,
        o.Order_ID,
        (oi.Total_Price / o.Gross_Amount) AS Product_Revenue_Share,
        o.Net_Amount
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT 
	p.Product_ID,
    p.Product_Name,
    COUNT(DISTINCT pl.Order_ID) AS Orders,
    ROUND(SUM(pl.Product_Revenue_Share * pl.Net_Amount), 2) AS Revenue_by_Product,
    ROUND(AVG(pl.Product_Revenue_Share * pl.Net_Amount), 2) AS Average_Revenue_Per_Product_Line,
    ROUND(
		(SUM(pl.Product_Revenue_Share * pl.Net_Amount) /
        (SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2
    ) AS Net_Revenue_Share_Percentage
FROM Products p
JOIN ProductLines pl ON p.Product_ID = pl.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue_by_Product DESC
LIMIT 10;

/*
=========================================================
End of REVENUE ANALYSIS

Total KPIs Implemented : 13

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS

Next:
ORDER ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 3
ORDER ANALYSIS

Business Objective:
	Analyze order volume, purchasing patterns, 
    and customer buying frequency to understand 
    transaction behavior.
=========================================================*/

-- =====================================================
-- KPI 01 : Orders by Month
-- Business Insight:
-- Shows monthly order trends and helps identify seasonal
-- changes in customer demand.
-- =====================================================
SELECT
	YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_No,
    MONTHNAME(Order_Date) AS Month,
    COUNT(Order_ID) AS Completed_Orders
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

-- =====================================================
-- KPI 02 : Orders by Weekday
-- Business Insight:
-- Compares order volume across weekdays to identify the
-- busiest days for business operations.
-- =====================================================
SELECT
	DAYNAME(Order_Date) AS Weekday,
    COUNT(Order_ID) AS Completed_Orders
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY WEEKDAY(Order_Date), DAYNAME(Order_Date)
ORDER BY WEEKDAY(Order_Date);

-- =====================================================
-- KPI 03 : Orders by Hour
-- Business Insight:
-- Highlights peak ordering hours to support staffing and
-- operational planning.
-- =====================================================
SELECT 
	HOUR(Order_Date) AS Hour,
    COUNT(*) AS Completed_Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV
FROM Orders
WHERE Order_Status = 'Completed'
GROUP BY HOUR(Order_Date)
ORDER BY Orders DESC;

-- =====================================================
-- KPI 04 : Average Items Per Order
-- Business Insight:
-- Measures the average number of items purchased in each
-- order to understand customer buying behavior.
-- =====================================================
SELECT
	COUNT(oi.Order_Item_ID) AS Total_Ordered_Items,
    SUM(oi.Quantity) AS Total_Units_Sold,
    COUNT(DISTINCT o.Order_ID) AS Total_Processed_Orders,
    ROUND(SUM(oi.Quantity)/COUNT(o.Order_ID), 2) AS Average_Items_Per_Order
FROM Order_Items oi
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed';

-- =====================================================
-- KPI 05 : Largest Order
-- Business Insight:
-- Identifies the order with the highest value or quantity,
-- highlighting major customer purchases.
-- =====================================================
SELECT 
	oi.Order_ID,
    COUNT(oi.Order_Item_ID) AS Items,
    SUM(oi.Quantity) AS Quantity
FROM Order_Items oi
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY Order_ID
ORDER BY Quantity DESC
LIMIT 10;

-- =====================================================
-- KPI 06 : Smallest Order
-- Business Insight:
-- Identifies the smallest order to understand low-value
-- purchasing patterns.
-- =====================================================
SELECT 
	oi.Order_ID,
    COUNT(oi.Order_Item_ID) AS Items,
    SUM(oi.Quantity) AS Quantity
FROM Order_Items oi
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY Order_ID
ORDER BY Quantity 
LIMIT 10;

-- =====================================================
-- KPI 07 : Orders by Status
-- Business Insight:
-- Shows the distribution of orders across different
-- statuses to monitor order fulfillment.
-- =====================================================
SELECT 
	Order_Status AS Status,
    COUNT(*) AS Orders,
    ROUND(COUNT(*) * 100 / (SUM(COUNT(*)) OVER()), 2) AS Order_Status_Percentage_Distribution
FROM Orders
GROUP BY Order_Status
ORDER BY Order_Status_Percentage_Distribution DESC;

-- =====================================================
-- KPI 08 : Average Processing Value by Status
-- Business Insight:
-- Compares the average order value for each order status
-- to identify performance differences.
-- =====================================================
SELECT
	Order_Status AS Status,
    COUNT(*) AS Orders,
    ROUND(AVG(Net_Amount), 2) AS Average_Processed_Order_Value
FROM Orders
GROUP BY Order_Status
ORDER BY Average_Net_Amount DESC;

-- =====================================================
-- KPI 09 : Orders by Basket Size
-- Business Insight:
-- Groups orders by the number of items purchased to
-- understand basket size distribution.
-- =====================================================
WITH OrderLineCounts AS (
    SELECT 
        Order_ID,
        COUNT(Order_Item_ID) AS Total_Unique_Items
    FROM Order_Items
    GROUP BY Order_ID
)
SELECT 
    CASE 
        WHEN olc.Total_Unique_Items = 1 THEN '1 Item'
        WHEN olc.Total_Unique_Items = 2 THEN '2 Items'
        WHEN olc.Total_Unique_Items = 3 THEN '3 Items'
        ELSE '4+ Items'
    END AS Basket_Size,
    COUNT(o.Order_ID) AS Orders
FROM Orders o
JOIN OrderLineCounts olc ON o.Order_ID = olc.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY Basket_Size
ORDER BY Basket_Size;

/*
=========================================================
End of ORDER ANALYSIS

Total KPIs Implemented : 9

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS

Next:
PRODUCT SALES
=========================================================
*/

/*=========================================================
SECTION 4
PRODUCT SALES

Business Objective:
	Identify best-selling products, product performance, 
    and customer purchasing preferences.
=========================================================*/

-- =====================================================
-- KPI 01 : Top Selling Products
-- Business Insight:
-- Identifies the products with the highest sales volume,
-- helping prioritize inventory and marketing efforts.
-- =====================================================
SELECT 
	p.Product_ID,
	p.Product_Name AS Products,
    SUM(oi.Quantity) AS Units_Sold
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Units_Sold DESC;

-- =====================================================
-- KPI 02 : Highest Revenue Products
-- Business Insight:
-- Shows which products generate the most revenue,
-- highlighting the business's top-performing items.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		o.Order_ID,
        oi.Product_ID,
		(oi.Total_Price / o.Gross_Amount) AS Item_Revenue_Share,
		o.Net_Amount
	FROM Order_Items oi
	JOIN Products p ON oi.Product_ID = p.Product_ID
	JOIN Orders o ON oi.Order_ID = o.Order_ID
	WHERE Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT 
	p.Product_ID,
	p.Product_Name AS Products,
    ROUND(SUM(ols.Item_Revenue_Share * ols.Net_Amount), 2) AS Completed_Revenue
FROM Products p
JOIN OrderLineShare ols ON p.Product_ID = ols.Product_ID
GROUP BY p.Product_ID, p.Product_Name 
ORDER BY Completed_Revenue DESC
LIMIT 10;

-- =====================================================
-- KPI 03 : Lowest Revenue Products
-- Business Insight:
-- Identifies products contributing the least revenue,
-- helping evaluate pricing or product strategy.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		o.Order_ID,
        oi.Product_ID,
		(oi.Total_Price / o.Gross_Amount) AS Item_Revenue_Share,
		o.Net_Amount
	FROM Order_Items oi
	JOIN Products p ON oi.Product_ID = p.Product_ID
	JOIN Orders o ON oi.Order_ID = o.Order_ID
	WHERE Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT 
	p.Product_ID,
	p.Product_Name AS Products,
    ROUND(SUM(ols.Item_Revenue_Share * ols.Net_Amount), 2) AS Completed_Revenue
FROM Products p
JOIN OrderLineShare ols ON p.Product_ID = ols.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Completed_Revenue 
LIMIT 10;

-- =====================================================
-- KPI 04 : Lowest Selling Products
-- Business Insight:
-- Highlights products with low sales volume that may
-- require promotion or inventory review.
-- =====================================================
SELECT
	p.Product_ID,
    p.Product_Name,
    SUM(oi.Quantity) AS Units_Sold
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Units_Sold
LIMIT 10;

-- =====================================================
-- KPI 05 : Highest Average Selling Price
-- Business Insight:
-- Identifies premium-priced products based on their
-- average selling price.
-- =====================================================
SELECT
	P.Product_ID,
    p.Product_Name,
    ROUND(AVG(Unit_Price), 2) AS Average_Selling_Price
FROM Order_items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Orders o ON oi.Order_ID = o.Order_Id
WHERE o.Order_Status = 'Completed'
GROUP BY P.Product_ID, p.Product_Name;

-- =====================================================
-- KPI 06 : Most Frequently Ordered Products
-- Business Insight:
-- Shows the products customers purchase most often,
-- indicating consistent demand.
-- =====================================================
SELECT 
	p.Product_ID,
	p.Product_Name AS Products,
    SUM(oi.Quantity) AS Units_Sold,
    COUNT(DISTINCT  oi.Order_ID) AS Orders_Appeared
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Orders_Appeared DESC;

-- =====================================================
-- KPI 07 : Products with Highest Return Count
-- Business Insight:
-- Identifies products with the highest number of returns
-- to help investigate quality or customer issues.
-- =====================================================
WITH ProductSalesSummary AS (
    SELECT 
        Product_ID,
        SUM(Quantity) AS Total_Units_Sold
    FROM Order_Items
    GROUP BY Product_ID
),
ProductReturnsSummary AS (
    SELECT 
        oi.Product_ID,
        SUM(r.Quantity_Returned) AS Total_Units_Returned
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    GROUP BY oi.Product_ID
)
SELECT 
	p.Product_ID,
    p.Product_Name AS Product,
    COALESCE(pr.Total_Units_Returned, 0) AS Returned_Items,
    ROUND( (COALESCE(pr.Total_Units_Returned, 0) / COALESCE(ps.Total_Units_Sold, 1)) * 100, 2) AS Product_Return_Rate
FROM Products p
JOIN ProductSalesSummary ps ON p.Product_ID = ps.Product_ID
JOIN ProductReturnsSummary pr ON p.Product_ID = pr.Product_ID
WHERE pr.Total_Units_Returned > 0
ORDER BY pr.Total_Units_Returned DESC, (COALESCE(pr.Total_Units_Returned, 0) / COALESCE(ps.Total_Units_Sold, 1)) DESC
LIMIT 10;

-- =====================================================
-- KPI 08 : Revenue Contribution (%)
-- Business Insight:
-- Measures each product's share of total revenue to
-- understand its business impact.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		oi.Product_ID,
        (oi.Total_Price / o.Gross_Amount) AS Item_Revenue_Share,
        o.Net_Amount
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND Gross_Amount >0
)
SELECT 
	p.Product_ID,
    p.Product_Name AS Products,
    ROUND(SUM(ols.Item_Revenue_Share * ols.Net_Amount), 2) AS Product_Revenue,
    ROUND(SUM(ols.Item_Revenue_Share * ols.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed') * 100, 2) AS Revenue_Contribution_Percentage
FROM Products p
JOIN OrderLineShare ols ON p.Product_ID = ols.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Revenue_Contribution_Percentage DESC;

-- =====================================================
-- KPI 09 : Inventory Value
-- Business Insight:
-- Calculates the total value of inventory available,
-- supporting stock and financial planning.
-- =====================================================
SELECT 
	Product_ID,
    Product_Name,
    Cost_Price,
    Current_Stock_Level,
    ROUND(Current_Stock_Level * Cost_Price, 2) AS Remaining_Stock_Value
FROM Products;
    
-- =====================================================
-- KPI 10 : Profit Margin
-- Business Insight:
-- Measures product profitability after accounting for
-- product costs.
-- =====================================================
WITH ProductPriceLine AS(
	SELECT 
		Product_ID,
        Product_Name,
        Cost_Price,
        Selling_Price,
        Selling_Price - Cost_Price AS Profit
    FROM Products
)
SELECT 
	Product_ID,
	Product_Name,
    ROUND(Profit * 100 / Selling_Price, 2) AS Profit_Margin
FROM ProductPriceLine;

-- =====================================================
-- KPI 11 : Inventory Turnover (Simplified)
-- Business Insight:
-- Shows how quickly inventory is sold, helping evaluate
-- stock movement and efficiency.
-- =====================================================
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Current_Stock_Level AS Current_Inventory,
    COALESCE(SUM(oi.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(oi.Quantity), 0) / 
		GREATEST(p.Current_Stock_Level, 1), 2) AS Simplified_Turnover_Ratio
FROM Products p
LEFT JOIN Order_Items oi ON p.Product_ID = oi.Product_ID
LEFT JOIN Orders o ON oi.Order_ID = o.Order_ID AND o.Order_Status = 'Completed'
GROUP BY p.Product_ID, p.Product_Name, p.Current_Stock_Level
ORDER BY Simplified_Turnover_Ratio DESC;

-- =====================================================
-- KPI 12 : Low Stock Alert
-- Business Insight:
-- Identifies products with low inventory levels so they
-- can be restocked on time.
-- =====================================================
SELECT
	Product_ID,
    Product_Name,
    Current_Stock_Level,
    Reorder_Level
FROM Products 
WHERE Current_Stock_Level <= Reorder_Level;

-- =====================================================
-- KPI 13 : Revenue Per Unit Sold
-- Business Insight:
-- Measures the average revenue generated for each unit
-- sold across products.
-- =====================================================
WITH LineItemNetShares AS (
    SELECT 
        oi.Product_ID,
        oi.Quantity,
        ((oi.Total_Price / o.Gross_Amount) * o.Net_Amount) AS Item_Proportional_Net_Revenue
    FROM Order_Items oi
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    WHERE o.Order_Status = 'Completed' 
      AND o.Gross_Amount > 0
)
SELECT 
    p.Product_ID,
    p.Product_Name AS Product,
    p.Selling_Price AS Catalog_Sticker_Price,
    SUM(lins.Quantity) AS Total_Units_Sold,
    ROUND(SUM(lins.Item_Proportional_Net_Revenue), 2) AS Total_Net_Revenue,
    ROUND(SUM(lins.Item_Proportional_Net_Revenue) / SUM(lins.Quantity), 2) AS Revenue_Per_Unit_Sold
FROM Products p
JOIN LineItemNetShares lins ON p.Product_ID = lins.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Selling_Price
ORDER BY Revenue_Per_Unit_Sold DESC;

/*
=========================================================
End of PRODUCT SALES

Total KPIs Implemented : 13

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES

Next:
STORE PERFORMANCE
=========================================================
*/

/*=========================================================
SECTION 5
STORE PERFORMANCE

Business Objective:
	Compare store performance across locations using 
    sales, orders, customers, and revenue metrics.
=========================================================*/

-- =====================================================
-- KPI 01 : Revenue by Store
-- Business Insight:
-- Compares revenue across stores to identify the highest
-- and lowest performing locations.
-- =====================================================
SELECT 
	s.Store_ID,
    s.Store_Name,
    COUNT(o.Order_ID) AS Orders,
    ROUND(SUM(o.Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(o.Net_Amount), 2) AS AOV,
    ROUND(SUM(o.Net_Amount)  / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed') * 100 , 2) AS Store_Revenue_Contribution_Percentage
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Completed_Revenue DESC;

-- =====================================================
-- KPI 02 : Orders by Store
-- Business Insight:
-- Measures order volume at each store to understand
-- customer demand across locations.
-- =====================================================
SELECT 
	s.Store_ID,
    s.Store_Name,
    COUNT(*) AS Orders
FROM Orders o
JOIN Stores s ON o.Store_ID = s.Store_ID
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Orders DESC;

-- =====================================================
-- KPI 03 : Average Order Value by Store
-- Business Insight:
-- Shows the average amount customers spend at each store,
-- helping compare purchasing behavior.
-- =====================================================
SELECT 
	s.Store_ID,
    s.Store_Name,
    ROUND(AVG(o.Net_Amount), 2) AS AOV
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY s.Store_ID;

-- =====================================================
-- KPI 04 : Revenue by City
-- Business Insight:
-- Compares revenue across cities to identify strong and
-- growing regional markets.
-- =====================================================
SELECT
	s.City,
    ROUND(SUM(o.Net_Amount), 2) AS Completed_City_Revenue
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.City
ORDER BY Completed_City_Revenue DESC;

-- =====================================================
-- KPI 05 : Revenue per Employee
-- Business Insight:
-- Measures the average revenue generated by each employee
-- to evaluate workforce productivity.
-- =====================================================
SELECT 
	e.Employee_ID,
    CONCAT(First_Name, ' ', Last_Name) AS Employee_Name,
    ROUND(SUM(o.Net_Amount) / COUNT(*), 2) AS Revenue_Per_Employee
FROM Employees e
JOIN Stores s ON e.Store_ID = s.Store_ID
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY e.Employee_ID,
    CONCAT(First_Name, '', Last_Name)
ORDER BY Revenue_Per_Employee DESC, e.Employee_ID ASC;

-- =====================================================
-- KPI 06 : Store Return Rate
-- Business Insight:
-- Tracks return rates for each store to identify locations
-- with higher product returns.
-- =====================================================
WITH ReturnSummary AS(
	SELECT 
        o.Store_ID,
        SUM(r.Quantity_Returned) AS Returned_Units
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    GROUP BY o.Store_ID
),
SaleSummary AS(
	SELECT 
		o.Store_ID,
        SUM(oi.Quantity) AS Sold_Units
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Store_ID
)
SELECT 
	s.Store_ID,
    s.Store_Name,
    COALESCE(ss.Sold_Units, 0) AS Total_Sold_Units,
    COALESCE(rs.Returned_Units, 0) AS Total_Returned_Units,
    ROUND((COALESCE(rs.Returned_Units, 0) / 
		GREATEST(COALESCE(ss.Sold_Units, 0), 1)) * 100, 2) AS Stores_Return_Rate_Percentage
FROM Stores s
LEFT JOIN ReturnSummary rs ON s.Store_ID = rs.Store_ID
LEFT JOIN SaleSummary ss ON s.Store_ID = ss.Store_ID
ORDER BY Stores_Return_Rate DESC;

-- =====================================================
-- KPI 07 : Revenue Contribution (%)
-- Business Insight:
-- Measures each store's contribution to total revenue,
-- showing its overall business impact.
-- =====================================================
SELECT 
	s.Store_ID,
    s.Store_Name,
    ROUND(SUM(o.Net_Amount), 2) AS Processed_Revenue,
    ROUND((SUM(o.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Stores_Revenue_Contribution
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Stores_Revenue_Contribution DESC;

-- =====================================================
-- KPI 08 : Store Ranking by Revenue
-- Business Insight:
-- Ranks stores based on revenue to identify top-performing
-- and underperforming locations.
-- =====================================================
SELECT 
	DENSE_RANK() OVER(
		ORDER BY ROUND(SUM(o.Net_Amount), 2) DESC
    ) AS Rank_By_Revenue,
	s.Store_ID,
    s.Store_Name,
    ROUND(SUM(o.Net_Amount), 2) AS Completed_Revenue
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Completed_Revenue DESC;

-- =====================================================
-- KPI 09 : Store Payment Preference
-- Business Insight:
-- Shows the most commonly used payment methods at each
-- store to understand customer preferences.
-- =====================================================
SELECT
	s.Store_ID,
    s.Store_Name,
    SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN 1 ELSE 0 END) AS Cash_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN pay.Amount_paid ELSE 0 END), 2) AS Cash_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN 1 ELSE 0 END) AS Credit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Credit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN 1 ELSE 0 END) AS Debit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Debit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN 1 ELSE 0 END) AS UPI_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN pay.Amount_paid ELSE 0 END), 2) AS UPI_Amount,
    COUNT(pay.Payment_ID) AS Total_Successful_Payments,
    ROUND(SUM(pay.Amount_paid), 2) AS Total_Successfully_Paid_Amount
FROM Orders o
JOIN Stores s ON o.Store_ID = s.Store_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
WHERE  pay.Payment_Status = 'Success'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY s.Store_ID ASC;

/*
=========================================================
End of STORE PERFORMANCE

Total KPIs Implemented : 9

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES
✔ STORE PERFORMANCE

Next:
CUSTOMER ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 6
CUSTOMER ANALYSIS

Business Objective:
	Analyze customer behavior, identify high-value 
    customers, and measure customer retention and 
    repeat purchases.
=========================================================*/

-- =====================================================
-- KPI 01 : Top Customers by Revenue
-- Business Insight:
-- Identifies customers who generate the highest revenue,
-- helping recognize the business's most valuable customers.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    COUNT(o.Order_ID) AS Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(Net_Amount), 2) AS AOV,
    ROUND((SUM(o.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Customer_Revenue_Contribution
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY Completed_Revenue DESC;

-- =====================================================
-- KPI 02 : Most Frequent Customers
-- Business Insight:
-- Shows customers who place orders most often, indicating
-- strong customer loyalty and engagement.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    COUNT(o.Order_ID) AS Completed_Orders
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY Orders DESC, Customer_ID;

-- =====================================================
-- KPI 03 : Highest Average Order Value
-- Business Insight:
-- Identifies customers with the highest average spending
-- per order.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    COUNT(o.Order_ID) AS Completed_Orders,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue,
    ROUND(SUM(Net_Amount) / COUNT(o.Order_ID), 2) AS AOV
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY AOV DESC
LIMIT 10;

-- =====================================================
-- KPI 04 : Customer Revenue Contribution (%)
-- Business Insight:
-- Measures each customer's contribution to total revenue,
-- highlighting their overall business value.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    ROUND(SUM(o.Net_Amount), 2) AS Processed_Revenue,
    ROUND((SUM(o.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Customer_Revenue_Percentage_Contribution
FROM CUstomers c
JOIN Orders o On c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY Customer_Revenue_Percentage_Contribution DESC;

-- =====================================================
-- KPI 05 : Customer Lifetime Value (CLV)
-- Business Insight:
-- Estimates the total revenue generated by each customer
-- throughout their relationship with the business.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    ROUND(SUM(Net_Amount), 2) AS Customer_Lifetime_Value
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY Customer_Lifetime_Value DESC;

-- =====================================================
-- KPI 06 : Last Purchase Date
-- Business Insight:
-- Shows when each customer last placed an order to
-- understand recent purchasing activity.
-- =====================================================
WITH CustomerOrderDateLine AS (
	SELECT 
		c.Customer_ID,
		CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
        o.Order_Date,
		ROW_NUMBER() OVER(
			PARTITION BY c.Customer_ID
			ORDER BY o.Order_Date DESC
		) rn
	FROM Customers c
	JOIN Orders o ON c.Customer_ID = o.Customer_ID
	WHERE o.Order_Status = 'Completed'
)
SELECT 
	Customer_ID,
    Customer_Name,
    Order_Date
FROM CustomerOrderDateLine
WHERE rn = 1;

-- =====================================================
-- KPI 07 : Days Since Last Purchase
-- Business Insight:
-- Measures how long it has been since a customer's last
-- purchase to identify inactive customers.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    DATEDIFF(CURDATE(), MAX(o.Order_Date)) AS Days_Since_Last_Purchase
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY Days_Since_Last_Purchase DESC;

-- =====================================================
-- KPI 08 : Customer Ranking
-- Business Insight:
-- Ranks customers based on their overall purchasing
-- performance and business value.
-- =====================================================
SELECT 
	DENSE_RANK() OVER(
		ORDER BY SUM(Net_Amount) DESC
    ) AS Customer_Rank,
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    ROUND(SUM(Net_Amount), 2) AS Completed_Revenue
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name);

-- =====================================================
-- KPI 09 : Orders by Store City
-- Business Insight:
-- Shows where customers place orders most frequently,
-- helping understand regional demand.
-- =====================================================
SELECT 
	s.City,
    COUNT(o.Customer_ID) AS Total_Customer
FROM Orders o
JOIN Stores s ON o.Store_ID = s.Store_ID
GROUP BY S.City
ORDER BY Total_Customer DESC;

-- =====================================================
-- KPI 10 : Customer Payment Preference
-- Business Insight:
-- Identifies the payment methods customers use most often
-- to understand payment preferences.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN 1 ELSE 0 END) AS Cash_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN pay.Amount_paid ELSE 0 END), 2) AS Cash_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN 1 ELSE 0 END) AS Credit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Credit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN 1 ELSE 0 END) AS Debit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Debit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN 1 ELSE 0 END) AS UPI_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN pay.Amount_paid ELSE 0 END), 2) AS UPI_Amount,
    COUNT(pay.Payment_ID) AS Total_Successful_Payments,
    ROUND(SUM(pay.Amount_paid), 2) AS Total_Successfully_Paid_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
WHERE  pay.Payment_Status = 'Success'
GROUP BY c.Customer_ID, CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY c.Customer_ID ASC;

-- =====================================================
-- KPI 11 : Average Basket Size
-- Business Insight:
-- Measures the average number of items purchased in each
-- customer order.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    SUM(oi.Quantity) AS Units_Purchased,
    COUNT(DISTINCT o.Order_ID) AS Orders,
    ROUND(SUM(oi.Quantity) / COUNT(DISTINCT o.Order_ID) , 2) AS Average_Basket_Size
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID, CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY c.Customer_ID ASC;

-- =====================================================
-- KPI 12 : Repeat Customer Rate
-- Business Insight:
-- Measures the percentage of customers who make more than
-- one purchase.
-- =====================================================
WITH CustomerOrderCount AS(
	SELECT
		Customer_ID,
        COUNT(Order_ID) AS Total_Orders
    FROM Orders o
    WHERE Order_Status = 'Completed'
    GROUP BY Customer_ID
),
CustomerSegmentation AS(
	SELECT
		Customer_ID,
        CASE
			WHEN Total_Orders > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS Category
    FROM CustomerOrderCount
)
SELECT 
	Category,
    COUNT(Customer_ID) AS Total_Customers,
    ROUND((COUNT(Customer_ID) / 
		(SELECT COUNT(DISTINCT Customer_ID) FROM Orders WHERE Order_Status = 'Completed')) *100, 2) AS Customer_Percentage
FROM CustomerSegmentation
GROUP BY Category
ORDER BY Customer_Percentage DESC;

-- =====================================================
-- KPI 13 : Customer Segmentation 
-- 				(VIP / Gold / Silver / Regular)
-- Business Insight:
-- Groups customers based on their purchasing behavior to
-- support targeted marketing strategies.
-- =====================================================
WITH CustomerRevenueLine AS(
	SELECT 
		c.Customer_ID,
		CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
		ROUND(SUM(o.Net_Amount), 2) AS Completed_Revenue
    FROM Customers c
    JOIN Orders o ON c.Customer_ID = o.Customer_ID
    WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name)
),
CustomerSegments AS(
	SELECT 
		Customer_ID,
        Customer_Name,
        Completed_Rvenue,
		CASE 
			WHEN Completed_Rvenue >= 5000000 THEN 'VIP'
            WHEN Completed_Rvenue >=4000000 THEN 'Gold'
            WHEN Completed_Rvenue >=2500000 THEN 'Silver'
            ELSE 'Regular'
        END AS Category
    FROM CustomerRevenueLine
)
SELECT 
	*
FROM CustomerSegments
ORDER BY Customer_ID ASC;

/*
=========================================================
End of CUSTOMER ANALYSIS

Total KPIs Implemented : 13

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES
✔ STORE PERFORMANCE
✔ CUSTOMER ANALYSIS

Next:
SUPPLIER ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 7
SUPPLIER ANALYSIS

Business Objective:
    Analyze supplier performance based on sales, inventory,
    profitability, and product returns to support better
    purchasing and supplier management decisions.
=========================================================*/

-- =====================================================
-- KPI 01 : Products by Supplier
-- Business Insight:
-- Shows the number of products supplied by each supplier,
-- helping evaluate supplier coverage.
-- =====================================================
SELECT
    sup.Supplier_ID,
    sup.Supplier_Name,
    COUNT(p.Product_ID) AS Total_Products
FROM Suppliers sup
JOIN Products p
ON sup.Supplier_ID = p.Supplier_ID
GROUP BY sup.Supplier_ID,
         sup.Supplier_Name
ORDER BY Total_Products DESC;

-- =====================================================
-- KPI 02 : Supplier Product Catalog
-- Business Insight:
-- Shows the number and variety of products supplied by
-- each supplier, helping evaluate supplier coverage and
-- product portfolio.
-- =====================================================
SELECT
	sup.Supplier_ID,
    sup.Supplier_Name,
    p.Product_ID,
    p.Product_Name
FROM Suppliers sup
JOIN Products p ON sup.Supplier_ID = p.Supplier_ID
ORDER BY Supplier_ID;

-- =====================================================
-- KPI 03 : Revenue by Supplier
-- Business Insight:
-- Measures the revenue generated from each supplier's
-- products to identify key business partners.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		p.Supplier_ID,
        oi.Quantity,
        o.Net_Amount,
        (oi.Total_Price / o.Gross_Amount) AS Supplier_Revenue_Share
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    WHERE o.Order_Status = 'Completed' 
		AND o.Gross_Amount > 0
)
SELECT 
	sup.Supplier_ID, 
    sup.Supplier_Name,
    SUM(ols.Quantity) AS Sold_Units,
    ROUND(SUM(ols.Supplier_Revenue_Share * ols.Net_Amount), 2) AS Completed_Revenue,
    ROUND(AVG(ols.Supplier_Revenue_Share * ols.Net_Amount), 2) AS Average_Revenue_Per_Supplier,
    ROUND(SUM(ols.Supplier_Revenue_Share * ols.Net_Amount) / 
		SUM(ols.Quantity), 2) AS Revenue_Per_Unit_Sold,
    ROUND((SUM(ols.Supplier_Revenue_Share * ols.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Supplier_Revenue_Contribution_Percentage
FROM Suppliers sup
JOIN OrderLineShare ols ON sup.Supplier_ID = ols.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Completed_Revenue DESC, Supplier_ID;

-- =====================================================
-- KPI 04 : Units Sold by Supplier
-- Business Insight:
-- Tracks the total quantity of products sold from each
-- supplier to understand product demand.
-- =====================================================
WITH OrderLine As(
	SELECT
		oi.Product_ID,
        oi.Quantity
    FROM Order_Items oi
    JOIN Orders o ON oi.Order_Id = o.Order_ID
    WHERE o.Order_Status = 'Completed'
)
SELECT 
	sup.Supplier_ID, 
    sup.Supplier_Name, 
    SUM(ol.Quantity) AS Sold_Units
FROM Suppliers sup
JOIN Products p ON sup.Supplier_ID = p.Supplier_ID
JOIN OrderLine ol ON p.Product_ID = ol.Product_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Sold_Units DESC, Supplier_ID;

-- =====================================================
-- KPI 05 : Return Rate by Supplier
-- Business Insight:
-- Measures the percentage of returned products for each
-- supplier to monitor product quality.
-- =====================================================
WITH SupplierSales AS(
	SELECT
		p.Supplier_ID,
        SUM(oi.Quantity) AS Units_Sold
    FROM Order_Items oi
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Supplier_ID
),
SupplierReturn As(
	SELECT
		p.Supplier_ID,
        SUM(r.Quantity_Returned) AS Units_Returned
    FROM Returns r 
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Supplier_ID
)
SELECT
	sup.Supplier_ID, 
    sup.Supplier_Name,
    COALESCE(sups.Units_Sold, 0) AS Sold_Units,
    COALESCE(supr.Units_Returned, 0) AS Returned_Units,
    ROUND((COALESCE(supr.Units_Returned, 0) / 
		GREATEST(COALESCE(sups.Units_Sold, 0), 1)) * 100, 2) AS Supplier_Return_Rate_Percentage
FROM Suppliers sup
LEFT JOIN SupplierSales sups ON sup.Supplier_ID = sups.Supplier_ID
LEFT JOIN SupplierReturn supr ON sup.Supplier_ID = supr.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Sold_Units DESC, Supplier_ID;

-- =====================================================
-- KPI 06 : Inventory Value by Supplier
-- Business Insight:
-- Calculates the total inventory value supplied by each
-- supplier to support inventory planning.
-- =====================================================
SELECT 
	sup.Supplier_ID, 
    sup.Supplier_Name,
    SUM(p.Current_Stock_Level) AS Current_Stock_Level,
    ROUND(SUM(p.Cost_Price * p.Current_Stock_Level), 2) AS Inventory_Value
FROM Suppliers sup
JOIN Products p ON sup.Supplier_ID = p.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name;

-- =====================================================
-- KPI 07 : Average Product Margin by Supplier
-- Business Insight:
-- Compares the average profit margin of products from
-- each supplier.
-- =====================================================
SELECT
    sup.Supplier_ID,
    sup.Supplier_Name,
    ROUND(
        AVG(p.Selling_Price - p.Cost_Price),
        2
    ) AS Average_Product_Margin
FROM Suppliers sup
JOIN Products p
ON sup.Supplier_ID = p.Supplier_ID
GROUP BY
    sup.Supplier_ID,
    sup.Supplier_Name
ORDER BY Average_Product_Margin DESC;

-- =====================================================
-- KPI 08 : Top Performing Supplier
-- Business Insight:
-- Identifies the supplier contributing the strongest
-- overall business performance.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		p.Supplier_ID,
        o.Net_Amount,
        (oi.Total_Price / o.Gross_Amount) AS Supplier_Revenue_Share
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    WHERE o.Order_Status = 'Completed' 
		AND o.Gross_Amount > 0
)
SELECT 
	sup.Supplier_ID, 
    sup.Supplier_Name,
    ROUND(SUM(ols.Supplier_Revenue_Share * ols.Net_Amount), 2) AS Completed_Revenue,
	DENSE_RANK() OVER(
		ORDER BY SUM(ols.Supplier_Revenue_Share * ols.Net_Amount) DESC
    )AS Supplier_Rank_By_Revenue
FROM Suppliers sup
JOIN OrderLineShare ols ON sup.Supplier_ID = ols.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Completed_Revenue DESC, Supplier_ID;

-- =====================================================
-- KPI 09 : Revenue Contribution (%)
-- Business Insight:
-- Shows each supplier's share of total revenue to
-- understand its overall business contribution.
-- =====================================================
WITH OrderLineShare AS(
	SELECT 
		p.Supplier_ID,
        o.Net_Amount,
        (oi.Total_Price / o.Gross_Amount) AS Supplier_Revenue_Share
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    WHERE o.Order_Status = 'Completed' 
		AND o.Gross_Amount > 0
)
SELECT 
	sup.Supplier_ID, 
    sup.Supplier_Name,
    ROUND(SUM(ols.Supplier_Revenue_Share * ols.Net_Amount), 2) AS Completed_Revenue,
    ROUND((SUM(ols.Supplier_Revenue_Share * ols.Net_Amount) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Supplier_Revenue_Contribution_Percentage
FROM Suppliers sup
JOIN OrderLineShare ols ON sup.Supplier_ID = ols.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Supplier_Revenue_Contribution_Percentage DESC, Supplier_ID;

-- =====================================================
-- KPI 10 : Supplier Portfolio
-- Business Insight:
-- Provides a complete overview of each supplier's
-- product portfolio, sales performance, inventory
-- contribution, and return metrics.
-- =====================================================
WITH SupplierSales AS(
	SELECT 
		p.Supplier_ID,
        p.Product_ID,
        oi.Quantity,
        o.Net_Amount,
        (oi.Total_Price / o.Gross_Amount) * o.Net_Amount AS Supplier_Propotional_Net_Revenue
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    WHERE o.Order_Status = 'Completed' 
		AND o.Gross_Amount > 0
),
SupplierReturn As(
	SELECT
		p.Supplier_ID,
        SUM(r.Quantity_Returned) AS Units_Returned,
        SUM(r.Refund_Amount) AS Revenue_Returned
    FROM Returns r 
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Supplier_ID
)
SELECT
	sup.Supplier_ID, 
    sup.Supplier_Name,
    COUNT(DISTINCT sups.Product_ID) As Total_Products,
    SUM(sups.Quantity) AS Sold_Units,
    ROUND(SUM(sups.Supplier_Propotional_Net_Revenue), 2) AS Completed_Revenue,
    ROUND((SUM(sups.Supplier_Propotional_Net_Revenue) / 
		(SELECT SUM(Net_Amount) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2) AS Supplier_Revenue_Contribution_Percentage,
    COALESCE(supr.Units_Returned, 0) AS Returned_Units,
    COALESCE(supr.Revenue_Returned, 0) AS Returned_Revenue,
    ROUND((COALESCE(supr.Units_Returned, 0) / 
		GREATEST(COALESCE(SUM(sups.Quantity), 0), 1)) * 100, 2) AS Supplier_Return_Rate_Percentage
FROM Suppliers sup
LEFT JOIN SupplierSales sups ON sup.Supplier_ID = sups.Supplier_ID
LEFT JOIN SupplierReturn supr ON sup.Supplier_ID = supr.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name
ORDER BY Supplier_ID ASC;


/*
=========================================================
End of SUPPLIER ANALYSIS

Total KPIs Implemented : 10

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES
✔ STORE PERFORMANCE
✔ CUSTOMER ANALYSIS
✔ SUPPLIER ANALYSIS

Next:
PAYMENT ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 8
PAYMENT ANALYSIS

Business Objective:
	Evaluate payment method usage and understand 
    customer payment preferences across transactions.
=========================================================*/

-- =====================================================
-- KPI 01 : Revenue Contribution by Payment Method
-- Business Insight:
-- Measures the revenue generated by each payment method
-- to understand its contribution to total sales.
-- =====================================================
SELECT 
	Payment_Method,
    COUNT(*) AS Payments,
    ROUND(SUM(Amount_paid), 2) AS Payment_Amount,
    ROUND(AVG(Amount_paid), 2) AS Average_Amount,
    ROUND(SUM(Amount_paid) * 100 / 
		(SELECT SUM(Amount_paid) FROM Payments WHERE Payment_Status = 'Success' ), 2) AS Revenue_Contribution_Percentage
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY Payments DESC;

-- =====================================================
-- KPI 02 : Payment Method Distribution
-- Business Insight:
-- Shows how customers choose different payment methods
-- across all transactions.
-- =====================================================
SELECT 
	Payment_Method,
    COUNT(*) AS Payments,
    ROUND(SUM(Amount_paid), 2) AS Payment_Amount,
    ROUND(AVG(Amount_paid), 2) AS Average_Amount,
    ROUND(COUNT(*) * 100 / 
		(SELECT COUNT(*) FROM Payments WHERE Payment_Status = 'Success' ), 2) AS Payment_Method_Distribution
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY Payments DESC;

-- =====================================================
-- KPI 03 : Payment Success Rate
-- Business Insight:
-- Measures the percentage of successful payments to
-- evaluate checkout performance.
-- =====================================================
SELECT 
    Payment_Method,
    SUM(CASE WHEN Payment_Status = 'Success' THEN 1 ELSE 0 END) AS Successful_Payments,
    COUNT(*) AS Total_Payments,
    ROUND(
        (SUM(CASE WHEN Payment_Status = 'Success' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Payment_Success_Rate_Percentage
FROM Payments
GROUP BY Payment_Method
ORDER BY Payment_Success_Rate_Percentage DESC;

-- =====================================================
-- KPI 04 : Payment Failure Rate
-- Business Insight:
-- Tracks failed payment attempts to identify potential
-- payment or checkout issues.
-- =====================================================
SELECT 
    Payment_Method,
    SUM(CASE WHEN Payment_Status = 'Failed' THEN 1 ELSE 0 END) AS Failed_Payments,
    COUNT(*) AS Total_Payments,
    ROUND(
        (SUM(CASE WHEN Payment_Status = 'Failed' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Payment_failed_Rate_Percentage
FROM Payments
GROUP BY Payment_Method
ORDER BY Payment_failed_Rate_Percentage DESC;

-- =====================================================
-- KPI 05 : Payment Status Distribution
-- Business Insight:
-- Shows the distribution of payment statuses across
-- all transactions.
-- =====================================================
SELECT
	Payment_Status,
    COUNT(Payment_Status) AS Payments,
    ROUND(COUNT(Payment_Status) * 100 / (SUM(COUNT(Payment_Status)) OVER()), 2 ) AS Payment_Status_Distribution
FROM Payments
GROUP BY Payment_Status
ORDER BY Payment_Status_Distribution DESC;

-- =====================================================
-- KPI 06 : Average Payment Amount
-- Business Insight:
-- Measures the average payment amount for each
-- payment method.
-- =====================================================
SELECT 
	Payment_Method,
	COUNT(*) AS Successfull_Payments,
    ROUND(SUM(Amount_paid), 2) AS Successfull_Amount,
    ROUND(SUM(Amount_paid) / COUNT(*), 2) AS Average_Payment_Amount
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY Average_Payment_Amount DESC;

-- =====================================================
-- KPI 07 : Revenue by Payment Method
-- Business Insight:
-- Compares revenue generated through each payment
-- method.
-- =====================================================
SELECT 
	Payment_Method,
    ROUND(SUM(Amount_paid), 2) AS Successfull_Revenue
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY Successfull_Revenue DESC;

-- =====================================================
-- KPI 08 : Monthly Payment Trend
-- Business Insight:
-- Tracks payment activity over time to identify
-- monthly trends and changes.
-- =====================================================
SELECT
	YEAR(Payment_Date) AS Year,
    MONTH(Payment_Date) AS Month_No,
    MONTHNAME(Payment_Date) AS Month,
    Payment_Method,
    COUNT(*) AS Payments,
    ROUND(SUM(Amount_paid), 2) AS Amount
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY YEAR(Payment_Date), MONTH(Payment_Date), MONTHNAME(Payment_Date), Payment_Method
ORDER BY Year, Month_No;

-- =====================================================
-- KPI 09 : Payment Method Contribution (%)
-- Business Insight:
-- Shows each payment method's share of total
-- transactions or revenue.
-- =====================================================
SELECT 
	Payment_Method,
    COUNT(*) AS Payments,
    ROUND(SUM(Amount_paid), 2) AS Amount,
    ROUND(SUM(Amount_paid) * 100 / 
		(SELECT SUM(Amount_paid) FROM Payments WHERE Payment_Status = 'Success' ), 2) AS Revenue_Contribution_Percentage
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY Revenue_Contribution_Percentage DESC;

-- =====================================================
-- KPI 10 : Failed Payments by Method
-- Business Insight:
-- Identifies which payment methods experience the
-- highest number of failed transactions.
-- =====================================================
SELECT 
	Payment_Method,
    COUNT(*) AS Failed_Payments
FROM Payments
WHERE Payment_Status = 'Failed'
GROUP BY Payment_Method;

-- =====================================================
-- KPI 11 : Refund Amount by Method
-- Business Insight:
-- Measures the total refund amount processed through
-- each payment method.
-- =====================================================
SELECT 
	Payment_Method,
    COUNT(*) AS Refunded_Payments,
    ROUND(SUM(Amount_paid), 2) AS Refunded_Amount
FROM Payments
WHERE Payment_Status = 'Refunded'
GROUP BY Payment_Method;

-- =====================================================
-- KPI 12 : Payment Ranking
-- Business Insight:
-- Ranks payment methods based on their usage or
-- revenue contribution.
-- =====================================================
SELECT 
	DENSE_RANK() OVER(
		ORDER BY SUM(Amount_paid) DESC
    ) AS Payment_Method_Rank,
    Payment_Method,
    COUNT(*) AS Successfull_Payments,
    ROUND(SUM(Amount_paid), 2) AS Successfull_Amount
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method;

-- =====================================================
-- KPI 13 : Store Payment Mix
-- Business Insight:
-- Compares payment method usage across stores to
-- understand local payment preferences.
-- =====================================================
SELECT
	s.Store_Name AS Store,
    SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN 1 ELSE 0 END) AS Cash_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN pay.Amount_paid ELSE 0 END), 2) AS Cash_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN 1 ELSE 0 END) AS Credit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Credit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN 1 ELSE 0 END) AS Debit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Debit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN 1 ELSE 0 END) AS UPI_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN pay.Amount_paid ELSE 0 END), 2) AS UPI_Amount,
    COUNT(pay.Payment_ID) AS Total_Successful_Payments,
    ROUND(SUM(pay.Amount_paid), 2) AS Total_Successfully_Paid_Amount
FROM Orders o
JOIN Stores s ON o.Store_ID = s.Store_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
WHERE  pay.Payment_Status = 'Success'
GROUP BY s.Store_Name;

-- =====================================================
-- KPI 14 : Customer Payment Preference
-- Business Insight:
-- Identifies the payment methods customers use most
-- frequently.
-- =====================================================
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN 1 ELSE 0 END) AS Cash_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Cash' THEN pay.Amount_paid ELSE 0 END), 2) AS Cash_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN 1 ELSE 0 END) AS Credit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Credit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Credit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN 1 ELSE 0 END) AS Debit_Card_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'Debit Card' THEN pay.Amount_paid ELSE 0 END), 2) AS Debit_Card_Amount,
    SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN 1 ELSE 0 END) AS UPI_Payments,
    ROUND(SUM(CASE WHEN pay.Payment_Method = 'UPI' THEN pay.Amount_paid ELSE 0 END), 2) AS UPI_Amount,
    COUNT(pay.Payment_ID) AS Total_Successful_Payments,
    ROUND(SUM(pay.Amount_paid), 2) AS Total_Successfully_Paid_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
WHERE  pay.Payment_Status = 'Success'
GROUP BY c.Customer_ID, CONCAT(c.First_Name, ' ', c.Last_Name)
ORDER BY c.Customer_ID ASC;

-- =====================================================
-- KPI 15 : Payment Method Growth
-- Business Insight:
-- Measures changes in payment method usage over time
-- to identify adoption trends.
-- =====================================================
WITH MonthlyPaymentTotals AS (
    SELECT
        YEAR(Payment_Date) AS Transaction_Year,
        Payment_Method,
        ROUND(SUM(Amount_Paid), 2) AS Current_Year_Revenue
    FROM Payments
    WHERE Payment_Status = 'Success'
    GROUP BY YEAR(Payment_Date), Payment_Method
)
SELECT
    Transaction_Year AS Year,
    Payment_Method,
    COALESCE(
        LAG(Current_Year_Revenue) OVER(
            PARTITION BY Payment_Method
            ORDER BY Transaction_Year
        ), 
        0.00
    ) AS Previous_Year_Revenue,
    ROUND(
        ((Current_Year_Revenue - LAG(Current_Year_Revenue) OVER(PARTITION BY Payment_Method ORDER BY Transaction_Year)) / 
        GREATEST(LAG(Current_Year_Revenue) OVER(PARTITION BY Payment_Method ORDER BY Transaction_Year), 1)) * 100,
        2
    ) AS Year_Over_Year_Growth_Percentage
FROM MonthlyPaymentTotals
ORDER BY Payment_Method, Year;

-- =====================================================
-- KPI 16 : Payment Method by Month
-- Business Insight:
-- Tracks monthly usage of each payment method to
-- identify seasonal trends.
-- =====================================================
SELECT
	YEAR(Payment_Date) AS Year,
    MONTH(Payment_Date) AS Month_No,
    MONTHNAME(Payment_Date) AS Month,
    SUM(CASE WHEN Payment_Method = 'Cash' THEN 1 ELSE 0 END) AS Cash_Payments,
    ROUND(SUM(CASE WHEN Payment_Method = 'Cash' THEN Amount_paid ELSE 0 END), 2) AS Cash_Amount,
    SUM(CASE WHEN Payment_Method = 'Credit Card' THEN 1 ELSE 0 END) AS Credit_Card_Payments,
    ROUND(SUM(CASE WHEN Payment_Method = 'Credit Card' THEN Amount_paid ELSE 0 END), 2) AS Credit_Card_Amount,
    SUM(CASE WHEN Payment_Method = 'Debit Card' THEN 1 ELSE 0 END) AS Debit_Card_Payments,
    ROUND(SUM(CASE WHEN Payment_Method = 'Debit Card' THEN Amount_paid ELSE 0 END), 2) AS Debit_Card_Amount,
    SUM(CASE WHEN Payment_Method = 'UPI' THEN 1 ELSE 0 END) AS UPI_Payments,
    ROUND(SUM(CASE WHEN Payment_Method = 'UPI' THEN Amount_paid ELSE 0 END), 2) AS UPI_Amount,
    COUNT(Payment_ID) AS Total_Successful_Payments,
    ROUND(SUM(Amount_paid), 2) AS Total_Successfully_Paid_Amount
FROM Payments 
WHERE Payment_Status = 'Success'
GROUP BY YEAR(Payment_Date), MONTH(Payment_Date), MONTHNAME(Payment_Date)
ORDER BY Year, Month_No ASC;

-- =====================================================
-- KPI 17 : Digital vs Cash
-- Business Insight:
-- Compares digital and cash payments to understand
-- customer payment behavior.
-- =====================================================
SELECT 
	CASE
		WHEN Payment_Method IN ('UPI', 'Credit Card', 'Debit Card') THEN 'Digital'
        ELSE 'Cash'
    END AS Payment_Infra_Type,
    COUNT(*) AS Payments,
    ROUND(SUM(Amount_paid), 2) AS Amount,
    ROUND(AVG(Amount_paid), 2) AS Average_Amount,
    ROUND(SUM(Amount_paid) * 100 / 
		(SELECT SUM(Amount_paid) FROM Payments WHERE Payment_Status = 'Success'), 2) AS Contribution
FROM Payments
WHERE Payment_Status = 'Success'
GROUP BY Payment_Infra_Type;

-- =====================================================
-- KPI 18 : Store Digital Adoption
-- Business Insight:
-- Measures the use of digital payments across stores
-- to evaluate digital payment adoption.
-- =====================================================
SELECT 
    s.Store_ID,
    s.Store_Name AS Store,
    SUM(CASE WHEN pay.Payment_Method IN ('UPI', 'Credit Card', 'Debit Card') THEN 1 ELSE 0 END) AS Digital_Transactions,
    COUNT(*) AS Total_Transactions,
    ROUND(
        (SUM(CASE WHEN pay.Payment_Method IN ('UPI', 'Credit Card', 'Debit Card') THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Digital_Adoption_Rate_Percentage
FROM Stores s
JOIN Orders o ON s.Store_ID = o.Store_ID
JOIN Payments pay ON o.Order_ID = pay.Order_ID
WHERE pay.Payment_Status = 'Success'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY Digital_Adoption_Rate_Percentage DESC;

/*
=========================================================
End of PAYMENT ANALYSIS

Total KPIs Implemented : 18

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES
✔ STORE PERFORMANCE
✔ CUSTOMER ANALYSIS
✔ SUPPLIER ANALYSIS
✔ PAYMENT ANALYSIS

Next:
RETURN ANALYSIS
=========================================================
*/

/*=========================================================
SECTION 9
RETURN ANALYSIS

Business Objective:
	Analyze return patterns, return rates, and 
    their impact on revenue and customer satisfaction.
=========================================================*/

-- =====================================================
-- KPI 01 : Overall Return Summary
-- Business Insight:
-- Provides an overview of return performance to measure
-- the overall impact of product returns.
-- =====================================================
SELECT 
	'Returned Orders' AS KPI, 
    COUNT(DISTINCT Order_ID) AS Value 
FROM Returns r 
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID

UNION ALL

SELECT 
	'Returned Units', 
    SUM(Quantity_Returned) 
FROM Returns

UNION ALL

SELECT 
	'Return Rate',
    ROUND((COUNT(*) / 
		(SELECT COUNT(*) FROM Orders WHERE Order_Status = 'Completed')) * 100, 2)
FROM Returns

UNION ALL

SELECT 
	'Returned Revenue', 
    SUM(Refund_Amount)
FROM Returns;

-- =====================================================
-- KPI 02 : Return Trend by Month
-- Business Insight:
-- Tracks monthly return trends to identify seasonal
-- patterns and changes over time.
-- =====================================================
SELECT
	YEAR(Return_Date) AS Year,
    MONTH(Return_Date) AS Month_No,
    MONTHNAME(Return_Date) AS Month,
    SUM(Quantity_Returned) AS Returned_Units,
    ROUND(SUM(Refund_Amount), 2) AS Returned_Revenue
FROM Returns
GROUP BY YEAR(Return_Date),
    MONTH(Return_Date),
    MONTHNAME(Return_Date)
ORDER BY Year, Month_No;

-- =====================================================
-- KPI 03 : Return by Product
-- Business Insight:
-- Identifies products with the highest number of returns
-- to help investigate product quality issues.
-- =====================================================
WITH ProductSaleSummary AS(
	SELECT 
		Product_ID,
        SUM(Quantity) AS Units_Sold
    FROM Order_Items
    GROUP BY Product_ID
),
ProductReturnSummary AS(
	SELECT
		oi.Product_ID,
        SUM(Quantity_Returned) AS Units_Returned
    FROM Returns r 
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    GROUP BY oi.Product_ID
)
SELECT
	p.Product_ID,
    p.Product_Name,
    COALESCE(ps.Units_Sold, 0) AS Sold_Units,
    COALESCE(pr.Units_Returned, 0) AS Returned_Units,
    ROUND((COALESCE(pr.Units_Returned, 0) / 
		GREATEST(COALESCE(ps.Units_Sold, 0), 1)) * 100, 2) AS Product_Return_Rate_Percentage
FROM Products p 
LEFT JOIN ProductSaleSummary ps ON p.Product_ID = ps.Product_ID
LEFT JOIN ProductReturnSummary pr ON p.Product_ID = pr.Product_ID
ORDER BY Product_Return_Rate_Percentage DESC, Product_ID ASC;

-- =====================================================
-- KPI 04 : Return by Category
-- Business Insight:
-- Compares return rates across product categories to
-- identify areas with higher return activity.
-- =====================================================
WITH CategorySaleSummary AS(
	SELECT 
		p.Category_ID,
        SUM(oi.Quantity) AS Units_Sold
    FROM Order_Items oi
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Category_ID
),
Category_Return_Summary AS(
	SELECT
		p.Category_ID,
        SUM(r.Quantity_Returned) AS Units_Returned
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Category_ID
)
SELECT 
	cat.Category_ID,
    cat.Category_Name,
    COALESCE(cs.Units_Sold, 0) AS Sold_Units,
    COALESCE(cr.Units_Returned, 0) AS Returned_Units,
    ROUND((COALESCE(cr.Units_Returned, 0) / 
		GREATEST(COALESCE(cs.Units_Sold, 0), 1)) * 100, 2) AS Category_Return_Rate_Percentage
FROM Categories cat
LEFT JOIN CategorySaleSummary cs ON cat.Category_ID = cs.Category_ID
LEFT JOIN Category_Return_Summary cr ON cat.Category_ID = cr.Category_ID
ORDER BY Category_Return_Rate_Percentage DESC, Category_ID ASC;

-- =====================================================
-- KPI 05 : Return by Store
-- Business Insight:
-- Measures return performance across stores to identify
-- location-specific trends.
-- =====================================================
WITH StoreSalesSummary AS (
    SELECT 
        Store_ID,
        SUM(Quantity) AS Units_Sold
    FROM Order_Items oi
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    GROUP BY Store_ID
),
StoreReturnsSummary AS (
    SELECT 
        o.Store_ID,
        SUM(r.Quantity_Returned) AS Units_Returned
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    GROUP BY o.Store_ID
)
SELECT
    s.Store_ID,
    s.Store_Name,
    COALESCE(ss.Units_Sold, 0) AS Sold_Units,
    COALESCE(sr.Units_Returned, 0) AS Returned_Units,
    ROUND((COALESCE(sr.Units_Returned, 0) / 
		GREATEST(COALESCE(ss.Units_Sold, 0), 1)) * 100, 2) AS Store_Return_Rate_Percentage
FROM Stores s
LEFT JOIN StoreSalesSummary ss ON s.Store_ID = ss.Store_ID
LEFT JOIN StoreReturnsSummary sr ON s.Store_ID = sr.Store_ID
ORDER BY Store_Return_Rate_Percentage DESC, s.Store_ID ASC;

-- =====================================================
-- KPI 06 : Customer Return Rate
-- Business Insight:
-- Measures how frequently customers return products to
-- better understand return behavior.
-- =====================================================
WITH CustomerSalesSummary AS(
	SELECT 
		o.Customer_ID,
        SUM(oi.Quantity) AS Units_sold
    FROM Order_Items oi
    JOIN Orders o ON oi.Order_ID = o.Order_Id
    GROUP BY o.Customer_ID
),
CustomerReturnSummary AS(
	SELECT
		o.Customer_ID,
        SUM(r.Quantity_Returned) AS Units_Returned
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    GROUP BY o.Customer_ID
)
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    COALESCE(cs.Units_sold, 0) AS Purchased_Units,
    COALESCE(cr.Units_Returned) AS Returned_Units,
    ROUND((COALESCE(cr.Units_Returned, 0) / 
		GREATEST(COALESCE(cs.Units_sold, 0), 1))* 100, 2) AS Customer_Return_Rate_Percentage
FROM Customers c
LEFT JOIN CustomerSalesSummary cs ON c.Customer_ID = cs.Customer_ID
LEFT JOIN CustomerReturnSummary cr ON c.Customer_ID = cr.Customer_ID
ORDER BY Customer_Return_Rate_Percentage DESC, Customer_ID ASC;

-- =====================================================
-- KPI 07 : Return Reason Analysis
-- Business Insight:
-- Analyzes return reasons to identify common issues and
-- opportunities for improvement.
-- =====================================================
SELECT
	Reason_for_Return AS Reason,
    COUNT(*) AS Returns,
    SUM(Quantity_Returned) AS Returned_Units,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS Return_Rate
FROM Returns 
GROUP BY Reason_for_Return
ORDER BY Return_Rate DESC;

-- =====================================================
-- KPI 08 : Revenue Lost Due to Returns
-- Business Insight:
-- Measures the revenue lost because of returned orders
-- and its impact on overall sales.
-- =====================================================
WITH ReturnedLineShares AS (
    SELECT 
        r.Return_ID,
        oi.Order_ID,
        (oi.Total_Price / o.Gross_Amount) AS Item_Revenue_Share,
        o.Net_Amount AS Order_Final_Net_Paid
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    WHERE o.Gross_Amount > 0
)
SELECT 
    COUNT(DISTINCT rls.Order_ID) AS Total_Impacted_Orders,
    COUNT(rls.Return_ID) AS Total_Returned_Line_Items,
    ROUND(SUM(rls.Item_Revenue_Share * rls.Order_Final_Net_Paid), 2) AS Realized_Net_Revenue_Lost
FROM ReturnedLineShares rls;

-- =====================================================
-- KPI 09 : Return Ranking
-- Business Insight:
-- Ranks products or categories based on return volume to
-- identify the highest-priority issues.
-- =====================================================
SELECT 
    '1. Store' AS Entity_Type,
    s.Store_Name AS Entity_Name,
    SUM(r.Quantity_Returned) AS Total_Returned_Units,
    DENSE_RANK() OVER (ORDER BY SUM(r.Quantity_Returned) DESC) AS Return_Rank
FROM Returns r
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
JOIN Stores s ON o.Store_ID = s.Store_ID
GROUP BY s.Store_ID, s.Store_Name

UNION ALL 

SELECT 
    '2. Category' AS Entity_Type,
    cat.Category_Name AS Entity_Name,
    SUM(r.Quantity_Returned) AS Total_Returned_Units,
    DENSE_RANK() OVER (ORDER BY SUM(r.Quantity_Returned) DESC) AS Return_Rank
FROM Returns r
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Categories cat ON p.Category_ID = cat.Category_ID
GROUP BY cat.Category_ID, cat.Category_Name

UNION ALL

SELECT 
    '3. Product' AS Entity_Type,
    p.Product_Name AS Entity_Name,
    SUM(r.Quantity_Returned) AS Total_Returned_Units,
    DENSE_RANK() OVER (ORDER BY SUM(r.Quantity_Returned) DESC) AS Return_Rank
FROM Returns r
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
JOIN Products p ON oi.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Entity_Type ASC, Return_Rank ASC;

-- =====================================================
-- KPI 10 : Repeat Return Customers
-- Business Insight:
-- Identifies customers with frequent returns to better
-- understand long-term return patterns.
-- =====================================================
WITH RepeatReturnCustomer AS(
	SELECT 
		c.Customer_ID,
		CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
        COUNT(r.Return_ID) AS Total_Returns
    FROM Returns r
    JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
    JOIN Orders o ON oi.Order_ID = o.Order_ID
    JOIN Customers c ON o.Customer_ID = c.Customer_ID
    GROUP BY c.Customer_ID,
		CONCAT(c.First_Name, ' ', c.Last_Name)
)
SELECT
	*
FROM RepeatReturnCustomer 
WHERE Total_Returns > 1
ORDER BY Total_Returns DESC, Customer_ID ASC;

/*
=========================================================
End of RETURN ANALYSIS

Total KPIs Implemented : 10

Sections Completed
✔ OVERALL SALES KPIs
✔ REVENUE ANALYSIS
✔ ORDER ANALYSIS
✔ PRODUCT SALES
✔ STORE PERFORMANCE
✔ CUSTOMER ANALYSIS
✔ SUPPLIER ANALYSIS
✔ PAYMENT ANALYSIS
✔ RETURN ANALYSIS

=========================================================
*/

/*
=========================================================

RetailHub Sales Analytics System

Total Sections : 9

Total KPIs : 118

Author : Micheal

End of File

=========================================================
*/