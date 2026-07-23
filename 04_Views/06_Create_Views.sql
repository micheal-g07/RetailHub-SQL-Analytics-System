/*
=========================================================
Project     : RetailHub Sales Analytics System
File        : 06_create_views.sql
Author      : Micheal
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Create Views
Version     : 1.0

Description:
	Creates reusable semantic views that simplify
	analytics queries, Power BI reporting,
	and business intelligence dashboards.

=========================================================
TABLE OF CONTENTS

1. Completed Orders
2. Order Details
3. Product Summary
4. Store Summary
5. Customer Summary
6. Payment Summary
7. Returns Summary
8. Inventory Summary
9. Product Inventory
10. Sales Fact

=========================================================
*/

USE RetailHub;

/*=========================================================
VIEW 1
COMPLETED ORDERS
=========================================================*/

DROP VIEW IF EXISTS vw_completed_orders;

CREATE VIEW vw_completed_orders AS 
SELECT 
	Order_ID,
    Customer_ID,
    Store_ID,
    Employee_ID,
    Order_Date,
    Gross_Amount,
    Discount_Amount,
    Tax_Amount,
    Net_Amount
FROM Orders 
WHERE Order_Status = 'Completed';


/*=========================================================
VIEW 2
ORDER DETAILS
=========================================================*/

DROP VIEW IF EXISTS vw_order_details;

CREATE VIEW vw_order_details AS
SELECT
	
    o.Order_ID,
    o.Order_Date,
    
    c.Customer_ID,
    CONCAT(c.First_Name,' ',c.Last_Name) AS Customer_Name,
    
    s.Store_ID,
    s.Store_Name,
    
    e.Employee_ID,
    CONCAT(e.First_Name,' ',e.Last_Name) AS Employee_Name,
    
    p.Product_ID,
    p.Product_Name,
    
    cat.Category_ID,
    cat.Category_Name,
    
    oi.Quantity,
    oi.Unit_Price,
    oi.Total_Price,
    
    o.Gross_Amount,
    o.Discount_Amount,
    o.Tax_Amount,
    o.Net_Amount

FROM Orders o

JOIN Customers c 
ON o.Customer_ID = c.Customer_ID

JOIN Stores s
ON o.Store_ID = s.Store_ID

JOIN Employees e
ON o.Employee_ID = e.Employee_ID

JOIN Order_Items oi
ON o.Order_ID = oi.Order_ID

JOIN Products p
ON oi.Product_ID= p.Product_ID

JOIN Categories cat
ON p.Category_ID = cat.Category_ID;


/*=========================================================
VIEW 3
PRODUCT SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_product_summary;

CREATE VIEW vw_product_summary AS
WITH ProductLine AS(
	SELECT
		oi.Product_ID,
        o.Order_ID,
        oi.Quantity,
        (oi.Total_Price / o.Gross_Amount) AS Product_Item_Revenue_Share,
        o.Net_Amount
	FROM Orders o 
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT
	p.Product_ID,
    p.Product_Name,
    COUNT(DISTINCT pl.Order_ID) AS Total_Orders,
    SUM(pl.Quantity) AS Units_Sold,
    ROUND(SUM(pl.Product_Item_Revenue_Share * pl.Net_Amount), 2) AS Revenue_By_Product,
    ROUND(AVG(pl.Product_Item_Revenue_Share * pl.Net_Amount), 2) AS Average_Revenue_Per_Order
FROM Products p
JOIN ProductLine pl ON p.Product_ID = pl.Product_ID
GROUP BY p.Product_ID,
    p.Product_Name;


/*=========================================================
VIEW 4
STORE SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_store_summary;

CREATE VIEW vw_store_summary AS
WITH StoreLine AS(
	SELECT
		o.Store_ID,
        o.Order_ID,
        oi.Quantity,
        (oi.Total_Price / o.Gross_Amount) AS Store_Item_Revenue_Share,
        o.Net_Amount
	FROM Orders o 
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT
	s.Store_ID,
    s.Store_Name,
    COUNT(DISTINCT sl.Order_ID) AS Total_Orders,
    SUM(sl.Quantity) AS Units_Sold,
    ROUND(SUM(sl.Store_Item_Revenue_Share * sl.Net_Amount), 2) AS Revenue_By_Store,
    ROUND(AVG(sl.Store_Item_Revenue_Share * sl.Net_Amount), 2) AS Average_Revenue_Per_Order
FROM Stores s
JOIN StoreLine sl ON s.Store_ID= sl.Store_ID
GROUP BY s.Store_ID,
    s.Store_Name;


/*=========================================================
VIEW 5
CUSTOMER SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_customer_summary;

CREATE VIEW vw_customer_summary AS
WITH CustomerLine AS(
	SELECT
		o.Customer_Id,
        o.Order_ID,
        oi.Quantity,
        (oi.Total_Price / o.Gross_Amount) AS Customer_Item_Revenue_Share,
        o.Net_Amount,
        o.Order_Date
	FROM Orders o 
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    WHERE o.Order_Status = 'Completed' AND o.Gross_Amount > 0
)
SELECT
	c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    COUNT(DISTINCT cl.Order_ID) AS Total_Orders,
    SUM(cl.Quantity) AS Units_Purchased,
    ROUND(SUM(cl.Customer_Item_Revenue_Share * cl.Net_Amount), 2) AS Revenue_By_Customer,
    ROUND(AVG(cl.Customer_Item_Revenue_Share * cl.Net_Amount), 2) AS Average_Revenue_Per_Order,
    MAX(cl.Order_Date) AS Last_Purchase
FROM Customers c
JOIN CustomerLine cl ON c.Customer_ID = cl.Customer_ID
GROUP BY c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name);
    
/*=========================================================
VIEW 6
SUPPLIER SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_supplier_summary;

CREATE VIEW vw_supplier_summary AS
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
    COALESCE(supr.Units_Returned, 0) AS Returned_Units,
    COALESCE(supr.Revenue_Returned, 0) AS Returned_Revenue
FROM Suppliers sup
LEFT JOIN SupplierSales sups ON sup.Supplier_ID = sups.Supplier_ID
LEFT JOIN SupplierReturn supr ON sup.Supplier_ID = supr.Supplier_ID
GROUP BY sup.Supplier_ID, 
    sup.Supplier_Name;

/*=========================================================
VIEW 7
PAYMENT SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_payment_summary;

CREATE VIEW vw_payment_summary AS
SELECT 
	pay.Payment_ID,
    pay.Order_ID,
    pay.Payment_Method,
    pay.Payment_Status,
    pay.Amount_paid,
    pay.Payment_Date,
    
    s.Store_ID,
    s.Store_Name,
    
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name
    
FROM Payments pay

JOIN Orders o 
ON pay.Order_ID = o.Order_ID

JOIN Stores s 
ON o.Store_ID = s.Store_ID

JOIN Customers c 
ON o.Customer_ID = c.Customer_ID;


/*=========================================================
VIEW 8
RETURN SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_return_summary;

CREATE VIEW vw_return_summary AS
SELECT 
	r.Return_ID,
    r.Return_Date,
    
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    
    s.Store_ID,
    s.Store_Name,
    
    p.Product_ID,
    p.Product_Name,
    
    cat.Category_ID,
    cat.Category_Name,
    
    r.Quantity_Returned,
    r.Refund_Amount,
    r.Reason_for_Return
FROM Returns r

JOIN Order_Items oi
ON r.Order_Item_ID = oi.Order_Item_ID

JOIN Products p
ON oi.Product_ID = p.Product_ID

JOIN Orders o
ON oi.Order_ID = o.Order_ID

JOIN Customers c
ON o.Customer_ID = c.Customer_ID

JOIN Stores s
ON o.Store_ID = s.Store_ID

JOIN Categories cat
ON p.Category_ID = cat.Category_ID;


/*=========================================================
VIEW 9
INVENTORY SUMMARY
=========================================================*/

DROP VIEW IF EXISTS vw_inventory_summary;

CREATE VIEW vw_inventory_summary AS
SELECT 
	Product_ID,
    Product_Name,
    Cost_Price,
    Selling_Price,
    Current_Stock_Level,
    ROUND(Cost_Price * Current_Stock_Level, 2) AS Inventory_Value,
    ROUND(Selling_Price * Current_Stock_Level, 2) AS Potential_Sales_Value,
    Reorder_Level
FROM Products;


/*=========================================================
VIEW 10
PRODUCT INVENTORY
=========================================================*/

DROP VIEW IF EXISTS vw_product_inventory;

CREATE VIEW vw_product_inventory AS
SELECT 

	p.Product_ID,
    p.Product_Name,
    
    cat.Category_ID,
    cat.Category_Name,
    
    p.Current_Stock_Level,
    p.Reorder_Level,
    p.Cost_Price,
    p.Selling_Price,
    ROUND(p.Cost_Price * p.Current_Stock_Level, 2) AS Inventory_Value,
    ROUND(p.Selling_Price * p.Current_Stock_Level, 2) AS Potential_Sales_Value,
    ROUND((P.Selling_Price - P.Cost_Price) * P.Current_Stock_Level, 2) AS Potential_Profit,
    ROUND(((P.Selling_Price - P.Cost_Price) * P.Current_Stock_Level) / p.Selling_Price, 2) AS Profit_Margin
    
FROM Products p 
JOIN Categories cat
ON p.Category_ID = cat.Category_ID;


/*=========================================================
VIEW 11
SALES FACT
=========================================================*/

DROP VIEW IF EXISTS vw_sales_fact;

CREATE VIEW vw_sales_fact AS
SELECT
	o.Order_ID,
    o.Order_Date,
    
    c.Customer_ID,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
    
    s.Store_ID,
    s.Store_Name,
    
    e.Employee_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    
    p.Product_ID,
    p.Product_Name,
    
    cat.Category_ID,
    cat.Category_Name,
    
    pay.Payment_ID,
    pay.Payment_Date,
    pay.Payment_Method,
    pay.Payment_Status,
    
    oi.Quantity,
    
    o.Discount_Amount,
    o.Net_Amount
    
FROM Orders o 

JOIN Order_Items oi
On o.Order_ID = oi.Order_ID

JOIN Customers c
ON o.Customer_ID = c.Customer_ID

JOIN Stores s
ON o.Store_ID = s.Store_ID

JOIN Employees e
ON o.Employee_ID = e.Employee_ID

JOIN Products p
ON oi.Product_ID = p.Product_ID

JOIN Categories cat
ON p.Category_ID = cat.Category_ID

JOIN Payments pay
ON o.Order_ID = pay.Order_ID

WHERE o.Order_Status = 'Completed';


/*
=========================================================

RetailHub Sales Analytics System

Total Views : 11

Author : Micheal

End of File

=========================================================
*/