"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Orders
==========================================
"""

import random
import os
import pandas as pd
from datetime import datetime, time
import utils
import config

def generate_orders_data():
    """
    Generates 5,000 order shell records mapping valid operational keys.
    Ensures employees only process transactions for their assigned store branch
    and locks down realistic status distribution ratios.
    """
    # 1. Load Parent Data to verify existential integrity constraints
    cust_path = os.path.join(config.OUTPUT_DIR, "customers.csv")
    store_path = os.path.join(config.OUTPUT_DIR, "stores.csv")
    emp_path = os.path.join(config.OUTPUT_DIR, "employees.csv")
    
    if not os.path.exists(cust_path) or not os.path.exists(store_path) or not os.path.exists(emp_path):
        raise FileNotFoundError("Parent files missing! Run customers, stores, and employees generators first.")
        
    cust_df = pd.read_csv(cust_path)
    store_df = pd.read_csv(store_path)
    emp_df = pd.read_csv(emp_path)

    # Map customers to their registration dates for chronological alignment
    customer_registry = dict(zip(cust_df["Customer_ID"], pd.to_datetime(cust_df["Registration_Date"]).dt.date))
    customer_ids = list(customer_registry.keys())

    # Map stores to their opening dates
    store_opening_registry = dict(zip(store_df["Store_ID"], pd.to_datetime(store_df["Opening_Date"]).dt.date))
    store_ids = list(store_opening_registry.keys())

    # ==============================================================================
    # CRITICAL MATCHING: MAP ACTIVE STAFF TO THEIR SPECIFIC STORE_ID
    # ==============================================================================
    # Filter for active staff to process orders, grouped by their assigned location
    active_emps = emp_df[emp_df["Status"] == "Active"]
    store_employee_map = active_emps.groupby("Store_ID")["Employee_ID"].apply(list).to_dict()
    
    # Global fallback list just in case a store layout contains no active staff
    global_active_employee_ids = active_emps["Employee_ID"].tolist()

    records = []

    # Defined corporate status probabilities matching your distribution profile
    status_pool = ['Pending', 'Completed', 'Cancelled', 'Returned']
    status_weights = [0.05, 0.88, 0.05, 0.02] # ~5%, ~88%, ~5%, ~2%

    for order_id in range(1, config.NUM_ORDERS + 1):
        # Select operational branch and matching buyer context
        customer_id = random.choice(customer_ids)
        store_id = random.choice(store_ids)
        
        # Enforce rule: Employee MUST belong to the selected store location
        available_cashiers = store_employee_map.get(store_id, global_active_employee_ids)
        employee_id = random.choice(available_cashiers)

        # Chronological Consistency: Order must happen AFTER customer signup AND AFTER store launch
        cust_reg_date = customer_registry[customer_id]
        store_open_date = store_opening_registry[store_id]
        max_start_date = max(cust_reg_date, store_open_date)

        order_date_pure = utils.generate_date(start_date=max_start_date, end_date=config.END_DATE)
        
        # Generate an active retail business operational timestamp using config variables
        random_time = time(
            random.randint(config.STORE_OPEN_HOUR, config.STORE_CLOSE_HOUR), 
            random.randint(0, 59), 
            random.randint(0, 59)
        )
        order_datetime = datetime.combine(order_date_pure, random_time)

        # Assign status using weighted retail distribution metrics
        order_status = random.choices(status_pool, weights=status_weights, k=1)[0]

        # Construct structural row layout, excluding monetary values for downstream compilation
        record = {
            "Order_ID": order_id,
            "Order_Date": order_datetime.strftime("%Y-%m-%d %H:%M:%S"),
            "Customer_ID": customer_id,
            "Store_ID": store_id,
            "Employee_ID": employee_id,
            "Order_Status": order_status
        }
        records.append(record)

    # Export records to output directory via utility helper
    utils.export_to_csv(records, "orders.csv")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_orders_data()

