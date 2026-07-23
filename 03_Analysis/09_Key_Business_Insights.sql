/*=========================================================
Project     : RetailHub Sales Analytics System
File        : 09_key_business_insights.sql
Author      : Michael
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Key Business Insights
Version     : 1.0

Description:
	Consolidate high-impact, portfolio-level 
    executive findings.
=========================================================*/

USE RetailHub;

-- =============================================================================
-- INSIGHT 1 & 2: OVERALL REVENUE, PROFITABILITY, & TAX footprint
-- =============================================================================
SELECT 
    'Financial Health' AS Focus_Area,
    CONCAT('₹', FORMAT(SUM(DISTINCT o.Net_Amount) / 100000, 2, 'en_IN'), ' Lakhs') AS Realized_Net_Revenue,
    CONCAT('₹', FORMAT((
        SUM((oi.Total_Price / o.Gross_Amount) * o.Net_Amount) - 
        SUM(oi.Quantity * p.Cost_Price)
    ) / 100000, 2, 'en_IN'), ' Lakhs') AS Est_Net_Profit,
    CONCAT(FORMAT(
        (SUM((oi.Total_Price / o.Gross_Amount) * o.Net_Amount) - SUM(oi.Quantity * p.Cost_Price)) / 
        SUM((oi.Total_Price / o.Gross_Amount) * o.Net_Amount) * 100, 
    2), '%') AS Net_Profit_Margin,
    CONCAT('₹', FORMAT(SUM(DISTINCT o.Gross_Amount * 0.18) / 100000, 2, 'en_IN'), ' Lakhs') AS GST_Tax_Collected
FROM Orders o
JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
JOIN Products p ON oi.Product_ID = p.Product_ID
WHERE o.Order_Status = 'Completed';


-- =============================================================================
-- INSIGHT 3 & 4: TOP DEPARTMENTS & VELOCITY ANCHOR PRODUCTS
-- =============================================================================
SELECT 
    'Top Product Category' AS Focus_Area,
    cat.Category_Name AS Dynamic_Anchor,
    SUM(oi.Quantity) AS Units_Sold,
    CONCAT('₹', FORMAT(SUM(oi.Total_Price) / 100000, 2, 'en_IN'), ' Lakhs') AS Gross_Sales
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Categories cat ON p.Category_ID = cat.Category_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY cat.Category_Name
ORDER BY SUM(oi.Total_Price) DESC
LIMIT 1;

SELECT 
    'Top Selling Product Line' AS Focus_Area,
    p.Product_Name AS Dynamic_Anchor,
    SUM(oi.Quantity) AS Units_Sold,
    CONCAT('₹', FORMAT(SUM(oi.Total_Price) / 100000, 2, 'en_IN'), ' Lakhs') AS Gross_Sales
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY p.Product_ID, p.Product_Name
ORDER BY SUM(oi.Total_Price) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 5: GEOGRAPHIC ANCHORS (TOP PERFORMING STORES)
-- =============================================================================
SELECT 
    'Top Flagship Hub' AS Focus_Area,
    s.Store_Name AS Dynamic_Anchor,
    COUNT(DISTINCT o.Order_ID) AS Total_Invoices,
    CONCAT('₹', FORMAT(SUM(o.Net_Amount) / 100000, 2, 'en_IN'), ' Lakhs') AS Revenue_Contribution
FROM Orders o
JOIN Stores s ON o.Store_ID = s.Store_ID
WHERE o.Order_Status = 'Completed'
GROUP BY s.Store_ID, s.Store_Name
ORDER BY SUM(o.Net_Amount) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 6: CUSTOMER VIP TIER ENGAGEMENT
-- =============================================================================
SELECT 
    'Top Customer Spend' AS Focus_Area,
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Dynamic_Anchor,
    COUNT(DISTINCT o.Order_ID) AS Total_Baskets,
    CONCAT('₹', FORMAT(SUM(oi.Total_Price) / 100000, 2, 'en_IN'), ' Lakhs') AS Lifetime_Value
FROM Order_Items oi
JOIN Orders o ON oi.Order_ID = o.Order_ID
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Order_Status = 'Completed'
GROUP BY c.Customer_ID, c.First_Name, c.Last_Name
ORDER BY SUM(oi.Total_Price) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 7: SUPPLY CHAIN ANCHORS (TOP SUPPLIERS)
-- =============================================================================
SELECT 
    'Top Strategic Supplier' AS Focus_Area,
    sup.Supplier_Name AS Dynamic_Anchor,
    COUNT(DISTINCT p.Product_ID) AS SKUs_Supplied,
    CONCAT('₹', FORMAT(SUM(oi.Total_Price) / 100000, 2, 'en_IN'), ' Lakhs') AS Inventory_Procured_Value
FROM Order_Items oi
JOIN Products p ON oi.Product_ID = p.Product_ID
JOIN Suppliers sup ON p.Supplier_ID = sup.Supplier_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_Status = 'Completed'
GROUP BY sup.Supplier_Name
ORDER BY SUM(oi.Total_Price) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 8: CHECKOUT ADOPTION VELOCITY (PAYMENT PERFORMANCE)
-- =============================================================================
SELECT 
    'Dominant Settlement Channel' AS Focus_Area,
    Payment_Method AS Dynamic_Anchor,
    COUNT(*) AS Txn_Count,
    CONCAT(FORMAT((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Payments WHERE Payment_Status = 'Success')), 2), '%') AS Volume_Share
FROM Payments 
WHERE Payment_Status = 'Success'
GROUP BY Payment_Method
ORDER BY COUNT(*) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 9 & 10: OPERATION REVERSALS (RETURN RATE & REASONS)
-- =============================================================================
SELECT 
    'Global Portfolio Return Rate' AS Focus_Area,
    CONCAT(FORMAT((SELECT SUM(Quantity_Returned) FROM Returns) * 100.0 / (SELECT SUM(Quantity) FROM Order_Items), 2), '%') AS Item_Return_Rate,
    CONCAT(FORMAT((SELECT COUNT(DISTINCT Order_ID) FROM Orders WHERE Order_Status = 'Returned') * 100.0 / COUNT(*), 2), '%') AS Impacted_Invoice_Share
FROM Orders;

SELECT 
    'Primary Return Leakage Reason' AS Focus_Area,
    Reason_for_Return AS Dynamic_Anchor,
    COUNT(*) AS Incident_Count,
    CONCAT(FORMAT((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Returns)), 2), '%') AS Reason_Share
FROM Returns
GROUP BY Reason_for_Return
ORDER BY COUNT(*) DESC
LIMIT 1;

-- =============================================================================
-- INSIGHT 11 & 12: INVENTORY POSITION & RESTOCK RISK
-- =============================================================================
SELECT 
    'Warehouse Capital Hold' AS Focus_Area,
    SUM(Current_Stock_Level) AS Total_Stock_On_Hand,
    COUNT(CASE WHEN Current_Stock_Level < Reorder_Level THEN 1 END) AS Low_Stock_Alert_SKUs,
    CONCAT(FORMAT((COUNT(CASE WHEN Current_Stock_Level < Reorder_Level THEN 1 END) * 100.0 / COUNT(*)), 2), '%') AS SKU_Stockout_Risk_Ratio
FROM Products;

/*
=========================================================

RetailHub Sales Analytics System

Total Insights : 12

Author : Micheal

End of File

=========================================================
*/