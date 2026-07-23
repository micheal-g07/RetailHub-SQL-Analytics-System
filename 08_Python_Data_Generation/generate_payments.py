"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Payments
==========================================
"""

import random
import os
import pandas as pd
from datetime import datetime, timedelta
import utils
import config

def generate_payments_data():
    """
    Generates exactly 5,000 clean payment records matching the 1:1 unique Order_ID relationship.
    Uses random.choice() instead of random.choices() to guarantee clean text without brackets.
    """
    # 1. Load synchronized orders file to extract Net_Amount and Order_Status
    orders_path = os.path.join(config.OUTPUT_DIR, "orders.csv")
    if not os.path.exists(orders_path):
        raise FileNotFoundError("❌ orders.csv not found! Run generate_order_items.py first.")
        
    orders_df = pd.read_csv(orders_path)
    records = []
    
    # 2. Define payment options as direct string pools
    payment_methods_pool = ['UPI', 'Credit Card', 'Debit Card', 'Cash']
    
    print("⏳ Rewriting and cleaning payment dataset structure...")

    for payment_id, (_, order_row) in enumerate(orders_df.iterrows(), start=1):
        order_id = int(order_row["Order_ID"])
        order_status = order_row["Order_Status"]
        net_amount = float(order_row["Net_Amount"])
        
        # Parse the original order timestamp string safely
        order_time = datetime.strptime(str(order_row["Order_Date"]), "%Y-%m-%d %H:%M:%S")
        
        # Chronological Consistency: Payment happens 1 to 10 minutes AFTER the order shell
        delay_minutes = random.randint(1, 10)
        payment_datetime = order_time + timedelta(minutes=delay_minutes)
        
        # Determine payment status based on current order life cycle
        if order_status == "Completed":
            payment_status = "Success"
            amount_paid = net_amount
        elif order_status == "Pending":
            payment_status = "Failed"
            amount_paid = 0.00
        elif order_status == "Cancelled":
            payment_status = "Failed"
            amount_paid = 0.00
        elif order_status == "Returned":
            payment_status = "Refunded"
            amount_paid = net_amount
        else:
            payment_status = "Success"
            amount_paid = net_amount

        # 🟢 FIX: Using random.choice() returns a single string item (e.g. "UPI")
        # This completely removes the list array brackets formatting bug!
        payment_method = random.choice(payment_methods_pool)
        
        record = {
            "Payment_ID": payment_id,
            "Order_ID": order_id,
            "Payment_Date": payment_datetime.strftime("%Y-%m-%d %H:%M:%S"),
            "Amount_Paid": amount_paid,
            "Payment_Method": payment_method,  # Outputs: UPI
            "Payment_Status": payment_status   # Outputs: Paid
        }
        records.append(record)
        
    # Export records to output directory via utility helper
    utils.export_to_csv(records, "payments.csv")
    print("✅ Successfully exported clean payments.csv with plain string text formats.")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_payments_data()


