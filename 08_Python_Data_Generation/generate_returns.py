"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Returns
==========================================
"""

import random
import os
import pandas as pd
from datetime import datetime, timedelta
import utils
import config

def generate_returns_data():
    """
    Generates 350-400 unique return records and back-updates the parent orders.csv 
    file to ensure Order_Status is set to 'Returned' for flawless data integrity.
    """
    # 1. Load Master Transaction Logs
    orders_path = os.path.join(config.OUTPUT_DIR, "orders.csv")
    items_path = os.path.join(config.OUTPUT_DIR, "order_items.csv")
    
    if not os.path.exists(orders_path) or not os.path.exists(items_path):
        raise FileNotFoundError("Master files missing! Run orders and order items generators first.")
        
    orders_df = pd.read_csv(orders_path)
    items_df = pd.read_csv(items_path)
    
    # Create lookups for dates and original status profiles
    order_dates_map = dict(zip(orders_df["Order_ID"], orders_df["Order_Date"]))
    all_items = items_df.to_dict(orient="records")
    
    # 2. Establish Target Return Volume Pool (Your exact 350 - 400 bracket)
    target_return_count = random.randint(360, 395)
    
    # Enforce 1:1 UNIQUE(Order_Item_ID) constraint by sampling unique lines
    sampled_return_items = random.sample(all_items, min(len(all_items), target_return_count))
    
    return_reasons_pool = [
        "Damaged Product", "Wrong Item Delivered", "Defective Product", 
        "Customer Changed Mind", "Size Issue"
    ]
    
    return_records = []
    returned_order_ids = set() # Tracks which orders must be updated to 'Returned' status

    print(f"Generating exactly {len(sampled_return_items)} return logs...")

    for return_id, item_row in enumerate(sampled_return_items, start=1):
        order_item_id = int(item_row["Order_Item_ID"])
        order_id = int(item_row["Order_ID"])
        quantity_bought = int(item_row["Quantity"])
        total_line_price = float(item_row["Total_Price"])
        
        # Log this order ID to update its parent shell status later
        returned_order_ids.add(order_id)
        
        # Chronological Consistency: Return happens 2 to 10 days AFTER the checkout purchase
        order_time = datetime.strptime(str(order_dates_map[order_id]), "%Y-%m-%d %H:%M:%S")
        delay_delta = timedelta(days=random.randint(2, 10), hours=random.randint(0, 23))
        return_datetime = order_time + delay_delta
        
        # Cap date line boundaries to prevent global timeline leaks
        max_limit = datetime.combine(config.END_DATE, datetime.max.time())
        if return_datetime > max_limit:
            return_datetime = max_limit

        record = {
            "Return_ID": return_id,
            "Order_Item_ID": order_item_id,
            "Return_Date": return_datetime.strftime("%Y-%m-%d %H:%M:%S"),
            "Quantity_Returned": quantity_bought,
            "Refund_Amount": total_line_price,
            "Reason_for_Return": random.choice(return_reasons_pool)
        }
        return_records.append(record)
        
    # Export clean items to output folder path directory
    utils.export_to_csv(return_records, "returns.csv")

    # ==============================================================================
    #  CRITICAL FIXED LINK: BACK-UPDATE ORDERS.CSV ORDER_STATUS
    # ==============================================================================
    print("Synchronizing data integrity: Linking returns back to parent order statuses...")
    
    orders_updated_count = 0
    for idx, row in orders_df.iterrows():
        oid = int(row["Order_ID"])
        # If this order contains a line item that was returned, change its parent status
        if oid in returned_order_ids:
            orders_df.at[idx, "Order_Status"] = "Returned"
            orders_updated_count += 1
            
    # Overwrite orders.csv with perfectly matched relational status fields
    orders_df.to_csv(orders_path, index=False)
    print(f"Successfully matched and updated {orders_updated_count} orders to 'Returned' status.")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_returns_data()


