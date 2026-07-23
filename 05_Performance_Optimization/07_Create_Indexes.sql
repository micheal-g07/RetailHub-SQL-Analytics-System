/*
=============================================
Project     : RetailHub Sales Analytics System
File        : 07_Create_Indexes.sql
Author      : Micheal
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Create Database Indexes
Version     : 1.0

Description:
	Creates indexes on frequently queried columns 
    to improve query performance, optimize JOIN
	operations, and accelerate filtering,
	sorting, and analytical reporting.
=============================================
*/

/*
Indexes are created only on frequently used
JOIN, WHERE, and ORDER BY columns.

Primary Keys and UNIQUE constraints are not
indexed here because MySQL creates those
indexes automatically.
*/

/*=========================================================
Orders

	1. Order Status
    2. Customer
    3. Store
    4. Order Date
    
Improves filtering by order status, customer,
store, and order date for sales reporting.
=========================================================*/

CREATE INDEX idx_orders_status
ON Orders(Order_Status);

CREATE INDEX idx_orders_customer
ON Orders(Customer_ID);

CREATE INDEX idx_orders_store
ON Orders(Store_ID);

CREATE INDEX idx_orders_date
ON Orders(Order_Date);

/*=========================================================
Order Items

    1. Order
    2. Product

Improves JOIN performance between orders and products,
speeding up sales, product, and revenue analysis.
=========================================================*/

CREATE INDEX idx_orderitems_order
ON Order_Items(Order_ID);

CREATE INDEX idx_orderitems_product
ON Order_Items(Product_ID);

/*=========================================================
Products

    1. Supplier
    2. Category

Supports supplier analysis and category reporting.
=========================================================*/

CREATE INDEX idx_products_supplier
ON Products(Supplier_ID);

CREATE INDEX idx_products_category
ON Products(Category_ID);

/*=========================================================
Stores

    1. City

Improves filtering and grouping by city for store
performance and regional sales analysis.
=========================================================*/

CREATE INDEX idx_stores_city
ON Stores(City);

/*=========================================================
Customers

    1. City

Improves filtering and grouping by customer location
for customer and regional sales analysis.
=========================================================*/

CREATE INDEX idx_customers_city
ON Customers(City);

/*=========================================================
Employees

    1. Store

Improves JOIN performance between employees and stores
for workforce and store performance analysis.
=========================================================*/

CREATE INDEX idx_employees_store
ON Employees(Store_ID);

/*=========================================================
Payments

    1. Payment Status
    2. Order
    3. Payment Method

Optimizes payment success and payment method analytics.
=========================================================*/

CREATE INDEX idx_payments_status
ON Payments(Payment_Status);

CREATE INDEX idx_payments_order
ON Payments(Order_ID);

CREATE INDEX idx_payments_method
ON Payments(Payment_Method);

/*=========================================================
Returns

    1. Order Item
    2. Return Date
    
Speeds up return trend and refund analysis.
=========================================================*/

CREATE INDEX idx_returns_orderitem
ON Returns(Order_Item_ID);

CREATE INDEX idx_returns_date
ON Returns(Return_Date);


-- =====================================================
-- Verify Created Indexes
-- =====================================================

SHOW INDEXES FROM Orders;

SHOW INDEXES FROM Order_Items;

SHOW INDEXES FROM Products;

SHOW INDEXES FROM Stores;

SHOW INDEXES FROM Customers;

SHOW INDEXES FROM Employees;

SHOW INDEXES FROM Payments;

SHOW INDEXES FROM Returns;


/*
=========================================================

RetailHub Sales Analytics System

Tables Indexed : 8

Indexes Created : 16

Author : Micheal

End of File

=========================================================
*/