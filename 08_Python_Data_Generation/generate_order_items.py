"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Order Items
==========================================
"""

import random
import os
import pandas as pd
import utils
import config

def generate_order_items_data():
    """
    Generates between 12,000 and 15,000 order item lines, enforces uq_order_product,
    and updates the empty monetary columns inside orders.csv using precise transactional math.
    """
    # 1. Load Parent Datasets to verify referential integrity
    products_path = os.path.join(config.OUTPUT_DIR, "products.csv")
    orders_path = os.path.join(config.OUTPUT_DIR, "orders.csv")
    
    if not os.path.exists(products_path) or not os.path.exists(orders_path):
        raise FileNotFoundError("Master catalog or order shells missing! Run products and orders generators first.")
        
    products_df = pd.read_csv(products_path)
    orders_df = pd.read_csv(orders_path)
    
    # Map products to their exact selling prices for rapid, stable matrix lookups
    product_prices = dict(zip(products_df["Product_ID"], products_df["Selling_Price"]))
    product_ids = list(product_prices.keys())
    order_ids = list(orders_df["Order_ID"])

    item_records = []
    item_id_tracker = 1
    
    # Initialize an aggregation dictionary to track accumulative order shell totals
    # Structure: { order_id: { 'gross': 0.0 } }
    order_totals = {oid: {"gross": 0.0} for oid in order_ids}

    # ==============================================================================
    # STEP 1: INITIAL PASS (GUARANTEE EVERY ORDER HAS AT LEAST 1 ITEM)
    # ==============================================================================
    for order_id in order_ids:
        product_id = random.choice(product_ids)
        quantity = utils.generate_quantity() # Generates bounded integer (1 to 5)
        unit_price = product_prices[product_id] # Snapshot price at moment of sale
        total_price = round(quantity * unit_price, 2)
        
        item_records.append({
            "Order_Item_ID": item_id_tracker,
            "Order_ID": order_id,
            "Product_ID": product_id,
            "Quantity": quantity,
            "Unit_Price": unit_price,
            "Total_Price": total_price
        })
        
        order_totals[order_id]["gross"] += total_price
        item_id_tracker += 1

    # ==============================================================================
    # STEP 2: FILL PASS (ADD RANDOM MULTI-LINES UP TO QUANTITY RANGE)
    # ==============================================================================
    # Maintain a set of composite pairs to strictly block unique constraint errors
    existing_combinations = {(rec["Order_ID"], rec["Product_ID"]) for rec in item_records}
    
    # Target row density to fit perfectly inside your 12,000 - 15,000 boundary conditions
    TARGET_TOTAL_ITEMS = 13500 
    
    max_attempts = 200000  # Fail-safe breaker loop trigger
    attempts = 0
    
    while len(item_records) < TARGET_TOTAL_ITEMS and attempts < max_attempts:
        attempts += 1
        order_id = random.choice(order_ids)
        product_id = random.choice(product_ids)
        
        # Enforce uq_order_product UNIQUE(Order_ID, Product_ID)
        if (order_id, product_id) in existing_combinations:
            continue
            
        existing_combinations.add((order_id, product_id))
        quantity = utils.generate_quantity()
        unit_price = product_prices[product_id]
        total_price = round(quantity * unit_price, 2)
        
        item_records.append({
            "Order_Item_ID": item_id_tracker,
            "Order_ID": order_id,
            "Product_ID": product_id,
            "Quantity": quantity,
            "Unit_Price": unit_price,
            "Total_Price": total_price
        })
        
        order_totals[order_id]["gross"] += total_price
        item_id_tracker += 1

    # Export compiled transaction lines to output folder
    utils.export_to_csv(item_records, "order_items.csv")

    # ==============================================================================
    # STEP 3: FINANCIAL SYNCHRONIZATION BACK INTO ORDERS.CSV
    # ==============================================================================
    print("Synchronizing calculated pricing math back into orders.csv...")
    
    # Initialize the blank columns inside the dataframe safely to hold decimals
    orders_df["Gross_Amount"] = 0.00
    orders_df["Discount_Amount"] = 0.00
    orders_df["Tax_Amount"] = 0.00
    orders_df["Net_Amount"] = 0.00

    for idx, row in orders_df.iterrows():
        oid = int(row["Order_ID"])
        gross = order_totals[oid]["gross"]
        
        # Retail Strategy: ~25% of purchases qualify for promotional loyalty discounts
        discount = 0.00
        if random.random() < 0.25:
            # Applies a clean, bounded promotional markdown markdown range (0% to 15% off)
            discount = round(gross * random.uniform(0.01, 0.15), 2)
            
        # Enforce standard 18% Indian GST (Goods and Services Tax) on post-discount subtotal
        taxable_subtotal = max(0.0, gross - discount)
        tax = round(taxable_subtotal * 0.18, 2)
        net = round(taxable_subtotal + tax, 2)
        
        # Update row cells systematically
        orders_df.at[idx, "Gross_Amount"] = round(gross, 2)
        orders_df.at[idx, "Discount_Amount"] = discount
        orders_df.at[idx, "Tax_Amount"] = tax
        orders_df.at[idx, "Net_Amount"] = net

    # Overwrite the temporary skeleton orders file with exact computed financial ledger metrics
    orders_df.to_csv(orders_path, index=False)
    print("Financial synchronization complete. orders.csv updated cleanly.")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_order_items_data()

