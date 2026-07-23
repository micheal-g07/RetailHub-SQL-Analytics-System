/*=========================================================
Project     : RetailHub Sales Analytics System
File        : 08_Triggers.sql
Author      : Michael
Database    : RetailHub
SQL Version : MySQL 8.0
Task        : Database Triggers
Version     : 1.0

Description:
Creates database triggers to enforce business rules,
maintain data integrity, and automate retail operations.

=========================================================*/

/*=========================================================
Trigger 1 : Prevent Update Negative Stock
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_negative_stock_update
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN

	IF NEW.Current_Stock_Level < 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Inventory level cannot be negative.';
	END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 2 : Prevent Insert Negative Stock
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_negative_stock_insert
BEFORE INSERT ON Order_Items
FOR EACH ROW
BEGIN
    DECLARE v_available_stock INT;

    SELECT Current_Stock_Level 
    INTO v_available_stock
    FROM Products 
    WHERE Product_ID = NEW.Product_ID;

    IF v_available_stock < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Operation aborted: Insufficient stock available to fulfill this purchase quantity.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 3 : Prevent Selling Below Cost
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_selling_below_cost
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
	IF NEW.Selling_Price < NEW.Cost_Price THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Selling Price cannot be less than Cost Price.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 4 : Prevent Update Negative Payment
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_negative_payment
BEFORE UPDATE ON Payments
FOR EACH ROW
BEGIN 
	IF NEW.Amount_Paid <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Amount Paid must be greater than zero.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 5 : Prevent Insert Negative Payment
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_negative_payment_insert
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN 
    IF NEW.Amount_Paid <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Operation aborted: Amount Paid must be greater than zero.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 6 : Prevent Future Orders
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_future_orders
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
	IF NEW.Order_Date > NOW() THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Order Date cannot be in the future.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 7 : Prevent Future Returns
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_future_returns
BEFORE INSERT ON Returns
FOR EACH ROW
BEGIN
	IF NEW.Return_Date > NOW() THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Return Date cannot be in the future.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 8 : Prevent Returned Quantity > Ordered Quantity
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_excessive_returns
BEFORE INSERT ON Returns
FOR EACH ROW
BEGIN
	
	DECLARE v_ordered_quantity INT;
    
    SELECT Quantity
    INTO v_ordered_quantity
    FROM Order_Items
    WHERE Order_Item_ID = NEW.Order_Item_ID;
    
    IF NEW.Quantity_Returned > v_ordered_quantity THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Operation aborted: Returned quantity cannot exceed purchased quantity.';
    END IF;
END //

DELIMITER ;

/*=========================================================
Trigger 9 : Auto Restore Inventory
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_auto_restore_inventory
AFTER INSERT ON Returns
FOR EACH ROW 
BEGIN
	UPDATE Products p
    JOIN Order_Items oi ON p.Product_ID = oi.Product_ID
    SET p.Current_Stock_Level = p.Current_Stock_Level + NEW.Quantity_Returned
    WHERE oi.Order_Item_ID = NEW.Order_Item_ID;
END //

DELIMITER ;

/*=========================================================
Trigger 10 : Prevent Duplicate Payment
=========================================================*/

DELIMITER //

CREATE TRIGGER trg_prevent_duplicate_payment
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
	
    DECLARE v_existing_success_count INT;
    
    IF NEW.Payment_Status = 'Success' THEN
		SELECT COUNT(*)
        INTO v_existing_success_count
        FROM Payments
        WHERE Order_ID = NEW.Order_ID
			AND Payment_Status = 'Success';
		
        IF v_existing_success_count > 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operation aborted: This order has already been successfully settled.';
		END IF;
    END IF;
END //

DELIMITER ;

/*
=========================================================

RetailHub Sales Analytics System

Total Triggers : 10

Author : Micheal

End of File

=========================================================
*/