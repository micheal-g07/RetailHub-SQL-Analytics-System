/*
=============================================
Project     : RetailHub Sales Analytics System
File        : 02_Create_Tables.sql
Author      : Micheal
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Create Tables
Version     : 1.0

Description:
	Creates all database tables,
	primary keys,
	foreign keys,
	constraints,
	and indexes.
=============================================
*/

USE RetailHub;

-- =============================================
-- Parent Tables
-- =============================================

-- Categories

CREATE TABLE Categories (
	Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(50) NOT NULL UNIQUE,
    Description TEXT NULL
);

-- Suppliers

CREATE TABLE Suppliers (
	Supplier_ID INT PRIMARY KEY AUTO_INCREMENT,
    Supplier_Name VARCHAR(100) NOT NULL,
    Contact_Name VARCHAR(100) NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE CHECK(CHAR_LENGTH(Phone)>= 10),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL
);

-- Stores

CREATE TABLE Stores (
	Store_ID INT PRIMARY KEY AUTO_INCREMENT,
    Store_Name VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Opening_Date DATE NOT NULL
);

-- Customers 

CREATE TABLE Customers (
	Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE CHECK (CHAR_LENGTH(Phone)>= 10),
    Gender ENUM('Male','Female','Other') NOT NULL,
    Date_of_Birth DATE NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Registration_Date DATE DEFAULT (CURRENT_DATE)
);

-- =============================================
-- Child Tables
-- =============================================

-- Employees

CREATE TABLE Employees (
	Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE CHECK (CHAR_LENGTH(Phone) >= 10),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    Hire_Date DATE NOT NULL,
    Store_ID INT NOT NULL,
    Status ENUM('Active','Inactive') DEFAULT 'Active',
    CONSTRAINT fk_emp_store 
		FOREIGN KEY (Store_ID) 
        REFERENCES Stores(Store_ID)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- Products

CREATE TABLE Products (
	Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(100) NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    Category_ID INT NOT NULL,
    Supplier_ID INT NOT NULL,
    Cost_Price DECIMAL(10,2) NOT NULL CHECK (Cost_Price > 0),
    Selling_Price DECIMAL(10,2) NOT NULL CHECK (Selling_Price > 0),
    Current_Stock_Level INT NOT NULL DEFAULT 0 CHECK (Current_Stock_Level >= 0),
    Reorder_Level INT NOT NULL DEFAULT 10 CHECK (Reorder_Level >= 0),
    Status ENUM('Active','Discontinued') DEFAULT 'Active',
    CONSTRAINT fk_prod_category 
		FOREIGN KEY (Category_ID) 
        REFERENCES Categories(Category_ID)
		ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    CONSTRAINT fk_prod_supplier 
		FOREIGN KEY (Supplier_ID) 
        REFERENCES Suppliers(Supplier_ID)
		ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- =============================================
-- Transaction Tables
-- =============================================

-- Orders

CREATE TABLE Orders (
	Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Customer_ID INT NOT NULL,
    Store_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    Gross_Amount DECIMAL(10,2) NOT NULL CHECK (Gross_Amount >= 0),
    Discount_Amount DECIMAL(10,2) DEFAULT 0.00 CHECK (Discount_Amount >= 0),
    Tax_Amount DECIMAL(10,2) NOT NULL CHECK (Tax_Amount >= 0),
    Net_Amount DECIMAL(10,2) NOT NULL CHECK (Net_Amount >= 0),
    Order_Status ENUM('Pending','Completed','Cancelled','Returned') DEFAULT 'Pending',
    CONSTRAINT fk_order_customer 
		FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_store 
		FOREIGN KEY (Store_ID)
        REFERENCES Stores(Store_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT fk_order_employee
		FOREIGN KEY (Employee_ID)
        REFERENCES Employees(Employee_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Order_Items

CREATE TABLE Order_Items (
	Order_Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price DECIMAL(10,2) NOT NULL CHECK (Unit_Price > 0),
    Total_Price DECIMAL(10,2) NOT NULL CHECK (Total_Price >= 0),
    CONSTRAINT fk_item_order
		FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_item_product 
		FOREIGN KEY (Product_ID)
        REFERENCES Products(Product_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT uq_order_product
		UNIQUE(Order_ID, Product_ID)
);

-- Payments

CREATE TABLE Payments (
	Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount_paid DECIMAL(10,2) NOT NULL CHECK (Amount_paid >= 0),
    Payment_Method ENUM('Cash','Credit Card','Debit Card','UPI') NOT NULL,
    Payment_Status ENUM('Success','Failed','Refunded') DEFAULT 'Success',
    CONSTRAINT fk_payment_order 
		FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Returns

CREATE TABLE Returns (
	Return_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_Item_ID INT NOT NULL UNIQUE,
    Return_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Quantity_Returned INT NOT NULL CHECK (Quantity_Returned > 0),
    Refund_Amount DECIMAL(10,2) NOT NULL CHECK (Refund_Amount >= 0),
    Reason_for_Return VARCHAR(255) NULL,
    CONSTRAINT fk_return_order_item
		FOREIGN KEY (Order_Item_ID)
        REFERENCES Order_Items(Order_Item_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


/*
=========================================================

RetailHub Sales Analytics System

Total Tables : 10

Author : Micheal

End of File

=========================================================
*/