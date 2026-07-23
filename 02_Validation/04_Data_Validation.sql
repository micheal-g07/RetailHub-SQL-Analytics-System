/*
=============================================
Project     : RetailHub Sales Analytics System
File        : 04_Data_Validation.sql
Author      : Micheal
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Data Validation
Version     : 1.0

Description:
	Performs data quality checks to identify
	missing values,
	duplicates,
	negative values,
	invalid foreign keys,
	and business rule violations.
=============================================
*/

USE RetailHub;

-- =============================================
-- 1. Row Count Validation
-- =============================================

-- Categories
SELECT
	'Categories' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Categories;

-- Suppliers
SELECT
	'Suppliers' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Suppliers;

-- Stores
SELECT
	'Stores' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Stores;

-- Customers
SELECT
	'Customers' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Customers;

-- Employees
SELECT
	'Employees' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Employees;

-- Products
SELECT
	'Products' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Products;

-- Orders
SELECT
	'Orders' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Orders;

-- Order_Items
SELECT
	'Order_Items' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Order_Items;

-- Payments
SELECT
	'Payments' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Payments;

-- Returns
SELECT
	'Returns' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Returns;

-- ====================================
-- 2. Primary Key Validation
-- ====================================

-- Defensive validation.
-- Expected: 0 rows.

-- Categories
SELECT 
	Category_ID,
    COUNT(*) AS Duplicate_Count
FROM Categories
GROUP BY Category_ID
HAVING COUNT(*) > 1;

-- Suppliers
SELECT 
	Supplier_ID,
    COUNT(*) AS Duplicate_Count
FROM Suppliers
GROUP BY Supplier_ID
HAVING COUNT(*) > 1;

-- Stores
SELECT 
	Store_ID,
    COUNT(*) AS Duplicate_Count
FROM Stores
GROUP BY Store_ID
HAVING COUNT(*) > 1;

-- Customers
SELECT 
	Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- Employees
SELECT 
	Employee_ID,
    COUNT(*) AS Duplicate_Count
FROM Employees
GROUP BY Employee_ID
HAVING COUNT(*) > 1;

-- Products
SELECT 
	Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

-- Orders
SELECT 
	Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Order_Items
SELECT 
	Order_Item_ID,
    COUNT(*) AS Duplicate_Count
FROM Order_Items
GROUP BY Order_Item_ID
HAVING COUNT(*) > 1;

-- Payments
SELECT 
	Payment_ID,
    COUNT(*) AS Duplicate_Count
FROM Payments
GROUP BY Payment_ID
HAVING COUNT(*) > 1;

-- Returns
SELECT 
	Return_ID,
    COUNT(*) AS Duplicate_Count
FROM Returns
GROUP BY Return_ID
HAVING COUNT(*) > 1;

-- =============================================
-- 3. Duplicate Validation 
-- =============================================

-- Duplicate Emails Validation

-- Suppliers
SELECT 
	Email,
    COUNT(*) AS Duplicate_Rows
FROM Suppliers
GROUP BY Email
HAVING COUNT(*) > 1;

-- Customers
SELECT 
	Email,
    COUNT(*) AS Duplicate_Rows
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- Employees
SELECT 
	Email,
    COUNT(*) AS Duplicate_Rows
FROM Employees
GROUP BY Email
HAVING COUNT(*) > 1;

-- Duplicate Phone Numbers Validation

-- Suppliers
SELECT 
	Phone,
    COUNT(*) AS Duplicate_Rows
FROM Suppliers
GROUP BY Phone
HAVING COUNT(*) > 1;

-- Customers
SELECT 
	Phone,
    COUNT(*) AS Duplicate_Rows
FROM Customers
GROUP BY Phone
HAVING COUNT(*) > 1;

-- Employees
SELECT 
	Phone,
    COUNT(*) AS Duplicate_Rows
FROM Employees
GROUP BY Phone
HAVING COUNT(*) > 1;

-- ====================================
-- 4. Missing Values Validation
-- ====================================

-- Categories
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Category_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Category_Name IS NULL OR Category_Name = '' THEN 1 ELSE 0 END) AS Missing_Name,
    SUM(CASE WHEN Description IS NULL OR Description = '' THEN 1 ELSE 0 END) AS Missing_Description
FROM Categories;

-- Suppliers
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Supplier_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Supplier_Name IS NULL OR Supplier_Name = '' THEN 1 ELSE 0 END) AS Missing_Supplier_Name,
    SUM(CASE WHEN Contact_Name IS NULL OR Contact_Name = '' THEN 1 ELSE 0 END) AS Missing_Contact_Name,
    SUM(CASE WHEN Email IS NULL OR Email = '' THEN 1 ELSE 0 END) AS Missing_Email,
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END) AS Missing_Phone_Number,
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS Missing_State
FROM Suppliers;

-- Stores
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Store_Name IS NULL OR Store_Name = '' THEN 1 ELSE 0 END) AS Missing_Name,
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS Missing_State,
    SUM(CASE WHEN Opening_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date
FROM Stores;

-- Customers
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN First_Name IS NULL OR First_Name = '' THEN 1 ELSE 0 END) AS Missing_First_Name,
    SUM(CASE WHEN Last_Name IS NULL OR Last_Name = '' THEN 1 ELSE 0 END) AS Missing_Last_Name,
    SUM(CASE WHEN Email IS NULL OR Email = '' THEN 1 ELSE 0 END) AS Missing_Email,
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END) AS Missing_Phone_Number,
    SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Date_of_Birth IS NULL THEN 1 ELSE 0 END) AS Missing_DoB,
    SUM(CASE WHEN City IS NULL OR City = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS Missing_State,
    SUM(CASE WHEN Registration_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Reg_Date
FROM Customers;

-- Employees
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Employee_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN First_Name IS NULL OR First_Name = '' THEN 1 ELSE 0 END) AS Missing_First_Name,
    SUM(CASE WHEN Last_Name IS NULL OR Last_Name = '' THEN 1 ELSE 0 END) AS Missing_Last_Name,
    SUM(CASE WHEN Email IS NULL OR Email = '' THEN 1 ELSE 0 END) AS Missing_Email,
    SUM(CASE WHEN Phone IS NULL OR Phone = '' THEN 1 ELSE 0 END) AS Missing_Phone_Number,
    SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Role IS NULL OR Role = '' THEN 1 ELSE 0 END) AS Missing_Role,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS Missing_Salary,
    SUM(CASE WHEN Hire_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Hire_Date,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Store_ID,
    SUM(CASE WHEN Status IS NULL OR Status = '' THEN 1 ELSE 0 END) AS Missing_Status
FROM Employees;

-- Products
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Product_Name IS NULL OR Product_Name = '' THEN 1 ELSE 0 END) AS Missing_Name,
    SUM(CASE WHEN SKU IS NULL THEN 1 ELSE 0 END) AS Missing_SKU,
    SUM(CASE WHEN Category_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Category_ID,
    SUM(CASE WHEN Supplier_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Supplier_ID,
    SUM(CASE WHEN Cost_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Cost,
    SUM(CASE WHEN Selling_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Selling_Price,
    SUM(CASE WHEN Current_Stock_Level IS NULL THEN 1 ELSE 0 END) AS Missing_Stock,
    SUM(CASE WHEN Reorder_Level IS NULL THEN 1 ELSE 0 END) AS Missing_Reorder,
    SUM(CASE WHEN Status IS NULL OR Status = '' THEN 1 ELSE 0 END) AS Missing_Status
FROM Products;

-- Orders
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Customer,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Store,
    SUM(CASE WHEN Employee_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Employee,
    SUM(CASE WHEN Gross_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Gross,
    SUM(CASE WHEN Discount_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Discount,
    SUM(CASE WHEN Tax_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Tax,
    SUM(CASE WHEN Net_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Net,
    SUM(CASE WHEN Order_Status IS NULL OR Order_Status = '' THEN 1 ELSE 0 END) AS Missing_Status
FROM Orders;

-- Order_Items
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Order_Item_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN Total_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Price
FROM Order_Items;

-- Payments
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Payment_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Payment_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Amount_paid IS NULL THEN 1 ELSE 0 END) AS Missing_Amount,
    SUM(CASE WHEN Payment_Method IS NULL OR Payment_Method = '' THEN 1 ELSE 0 END) AS Missing_Method,
    SUM(CASE WHEN Payment_Status IS NULL OR Payment_Status = '' THEN 1 ELSE 0 END) AS Missing_Status
FROM Payments;

-- Returns
SELECT 
	COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Return_ID IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN Order_Item_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Item,
    SUM(CASE WHEN Return_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Date,
    SUM(CASE WHEN Quantity_Returned IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN Refund_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Amount,
    SUM(CASE WHEN Reason_for_Return IS NULL OR Reason_for_Return = '' THEN 1 ELSE 0 END) AS Missing_Reason
FROM Returns;

-- ========================================================
-- 5. Business Rule Validation 
-- ========================================================

-- Negative Salaries, Prices, Amounts, Stocks and Quantity Validation

-- Employees Salary
SELECT 
	'Negative Salary' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Employees
WHERE Salary < 0;

-- Products Cost_Price
SELECT 
	'Negative Cost Price' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Products
WHERE Cost_Price < 0;
-- Products Selling_Price
SELECT 
	'Negative Selling Price' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Products
WHERE Selling_Price < 0;
-- Products Current_Stock_Level
SELECT 
	'Negative Current Stock Level' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Products
WHERE Current_Stock_Level < 0;
-- Products Reorder_Level
SELECT 
	'Negative Reorder Level' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Products
WHERE Reorder_Level < 0;

-- Orders Gross_Amount
SELECT 
	'Negative Gross Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Orders
WHERE Gross_Amount < 0;
-- Orders Discount_Amount
SELECT 
	'Negative Discount Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Orders
WHERE Discount_Amount < 0;
-- Orders Tax_Amount
SELECT 
	'Negative Tax Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Orders
WHERE Tax_Amount < 0;
-- Orders Net_Amount
SELECT 
	'Negative Net Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Orders
WHERE Net_Amount < 0;

-- Order_Items Quantity
SELECT 
	'Negative Quantity' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Order_Items
WHERE Quantity < 0;
-- Order_Items Unit_Price
SELECT 
	'Negative Unit Price' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Order_Items
WHERE Unit_Price < 0;
-- Order_Items Total_Price
SELECT 
	'Negative Total Price' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Order_Items
WHERE Total_Price < 0;

-- Payments Amount_Paid
SELECT 
	'Negative Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Payments
WHERE Amount_Paid < 0;

-- Returns Quantity_Returned
SELECT 
	'Negative Quantity' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Returns
WHERE Quantity_Returned < 0;
-- Quantity Refund_Amount
SELECT 
	'Negative Amount' AS Validation_Check,
    COUNT(*) AS Failed_Rows
FROM Returns
WHERE Refund_Amount < 0;

-- =============================================
-- 6. Cross-Table Business Rule Validation
-- =============================================

-- Employee Hired Before Store Opening
SELECT
	e.Employee_ID,
    e.Hire_Date,
    s.Opening_Date
FROM Employees e
JOIN Stores s ON e.Store_ID = s.Store_ID
WHERE e.Hire_Date < s.Opening_Date;

-- Orders Before Customer Registration
SELECT 
	o.Order_ID,
    o.Order_Date,
    c.Registration_Date
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Customer_ID < c.Customer_ID;

-- Payments Before Order
SELECT
	pay.Payment_ID,
    pay.Payment_Date,
    o.Order_Date
FROM Payments pay
JOIN Orders o ON pay.Order_ID = o.Order_ID
WHERE pay.Order_ID < o.Order_ID;

-- Return Before Purchase
SELECT
	Return_ID
FROM Returns r
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE r.Return_Date < o.Order_Date;

-- =============================================
-- 7. Referential Integrity Validation
-- =============================================

-- Employees - FK Store_ID
SELECT 
	*
FROM Employees e
LEFT JOIN Stores s ON e.Store_ID = s.Store_ID
WHERE s.Store_ID IS NULL;

-- Products - FK Category_ID
SELECT 
	*
FROM Products p
LEFT JOIN Categories cat ON p.Category_ID = cat.Category_ID
WHERE cat.Category_ID IS NULL;

-- Products - FK Supplier_ID
SELECT 
	*
FROM Products p
LEFT JOIN Suppliers sup ON p.Supplier_ID = sup.Supplier_ID
WHERE sup.Supplier_ID IS NULL;

-- Orders - FK Customer_ID
SELECT 
	*
FROM Orders o
LEFT JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- Orders - FK Store_ID
SELECT 
	*
FROM Orders o
LEFT JOIN Stores s ON o.Store_ID = s.Store_ID
WHERE s.Store_ID IS NULL;

-- Orders - FK Employee_ID
SELECT 
	*
FROM Orders o
LEFT JOIN Employees e ON o.Employee_ID = e.Employee_ID
WHERE e.Employee_ID IS NULL;

-- Order_Items - FK Order_ID
SELECT 
	*
FROM Order_Items oi
LEFT JOIN Orders o ON oi.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

-- Order_Items - FK Product_ID
SELECT 
	*
FROM Order_Items oi
LEFT JOIN Products p ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

-- Payments - FK Order_ID
SELECT 
	*
FROM Payments pay
LEFT JOIN Orders o ON pay.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;

-- Returns - FK Order_Item_ID
SELECT 
	*
FROM Returns r
LEFT JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
WHERE oi.Order_Item_ID IS NULL;

-- =============================================
-- 8. Financial Validation
-- =============================================
SELECT 
	Order_ID
FROM Orders
WHERE ROUND(
	Gross_Amount
    -
    Discount_Amount
    +
    Tax_Amount, 2
) != Net_Amount;

-- =============================================
-- 9. Mismatch Return Validation
-- =============================================
SELECT 
    COUNT(DISTINCT o.Order_ID) AS Total_Returned_Orders_In_Parent_Table,
    COUNT(DISTINCT oi.Order_ID) AS Total_Returned_Orders_Linked_To_Returns_Table,
    SUM(CASE WHEN o.Order_Status != 'Returned' THEN 1 ELSE 0 END) AS Mismatched_Status_Anomalies
FROM Returns r
JOIN Order_Items oi ON r.Order_Item_ID = oi.Order_Item_ID
JOIN Orders o ON oi.Order_ID = o.Order_ID;

-- =============================================
-- 10. Validation Summary
-- =============================================

SELECT
	'Categories' AS Table_Name,
	COUNT(*) AS Total_Rows
FROM Categories
UNION ALL
SELECT
	'Suppliers',
	COUNT(*) AS Total_Rows
FROM Suppliers
UNION ALL
SELECT
	'Stores',
	COUNT(*) AS Total_Rows
FROM Stores
UNION ALL
SELECT
	'Customers',
	COUNT(*) AS Total_Rows
FROM Customers
UNION ALL
SELECT
	'Employees',
	COUNT(*) AS Total_Rows
FROM Employees
UNION ALL
SELECT
	'Products',
	COUNT(*) AS Total_Rows
FROM Products
UNION ALL
SELECT
	'Orders',
	COUNT(*) AS Total_Rows
FROM Orders
UNION ALL
SELECT
	'Order_Items',
	COUNT(*) AS Total_Rows
FROM Order_Items
UNION ALL
SELECT
	'Payments',
	COUNT(*) AS Total_Rows
FROM Payments
UNION ALL
SELECT
	'Returns',
	COUNT(*) AS Total_Rows
FROM Returns;


/*
=========================================================

RetailHub Sales Analytics System

Total Sections : 10

Total Validations : 68

Author : Micheal

End of File

=========================================================
*/