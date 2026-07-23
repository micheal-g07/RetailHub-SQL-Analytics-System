"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Products
==========================================
"""

import random
import os
import pandas as pd
import utils
import config

def generate_products_data():
    """
    Generates exactly 250 realistic product profiles with category-matching names,
    calculated profit margins, and intentional low-stock items for alerting reports.
    """
    # 1. Load Parent Data to verify existential integrity constraints
    cat_path = os.path.join(config.OUTPUT_DIR, "categories.csv")
    sup_path = os.path.join(config.OUTPUT_DIR, "suppliers.csv")
    
    if not os.path.exists(cat_path) or not os.path.exists(sup_path):
        raise FileNotFoundError("Parent files missing! Run categories and suppliers generators first.")
        
    cat_df = pd.read_csv(cat_path)
    sup_df = pd.read_csv(sup_path)
    
    category_ids = list(cat_df["Category_ID"])
    supplier_ids = list(sup_df["Supplier_ID"])

    # Mapping realistic, specific products to Category_IDs (1 to 10)
    category_product_catalog = {
        1: ["iPhone Leather Case", "Anker Bluetooth Speaker", "Ergonomic Laptop Stand", "Sony Wireless Headphones", "USB-C Hub Adapter"],
        2: ["Panasonic Microwave Oven", "IFB Front Load Washing Machine", "Samsung Refrigerator", "Dyson Vacuum Cleaner", "Philips Air Fryer"],
        3: ["Mesh Office Chair", "Wooden Study Table", "3-Seater Fabric Sofa", "King Size Storage Bed", "5-Tier Bookshelf"],
        4: ["Levis Slim Fit Jeans", "Premium Cotton T-Shirt", "Zegna Formal Dress Shirt", "Zara Summer Dress", "Nike Fleece Hoodie"],
        5: ["Puma Running Shoes", "Bata Leather Loafers", "Adidas Sports Sandals", "Steve Madden Heels", "Converse Chuck Taylor Sneakers"],
        6: ["Cetaphil Moisturizer", "Neutrogena Sunscreen", "L'Oreal Charcoal Face Wash", "Maybelline Matte Lipstick", "Titan Skinn Perfume"],
        7: ["Reebok 6mm Yoga Mat", "Decathlon 10kg Dumbbell Set", "Fitkit Motorized Treadmill", "Yonex Badminton Racket", "Milton Insulated Water Bottle"],
        8: ["LEGO Classic Building Blocks", "Mattel Monopoly Board Game", "Marvel Iron Man Action Figure", "Hot Wheels Track Set", "Ravensburger 1000pc Puzzle"],
        9: ["Daawat Basmati Rice", "Borges Extra Virgin Olive Oil", "Aashirvaad Whole Wheat Atta", "Dabur Organic Honey", "Twinings Green Tea Bags"],
        10: ["Classmate Notebook Pack", "Parker Vector Gel Pen Set", "Agatha Christie Mystery Novel", "Dune Sci-Fi Paperback Book", "Metal Desk Organizer Mesh"]
    }

    records = []
    generated_skus = set()

    for product_id in range(1, config.NUM_PRODUCTS + 1):
        # Pick existential IDs securely from verified arrays
        category_id = random.choice(category_ids)
        supplier_id = random.choice(supplier_ids)

        # Retrieve specific product names belonging directly to the assigned category
        catalog_pool = category_product_catalog.get(category_id, ["Generic Retail Item"])
        product_base_name = random.choice(catalog_pool)
        
        # Add random model identifiers to handle multiple catalog entries cleanly
        model_variant = random.choice(["V1", "Pro", "Max", "Classic", "Plus", "Lite"])
        product_name = f"{product_base_name} {model_variant}"

        # Generate a structured unique corporate SKU code
        dept_prefix = f"CAT{category_id:02d}"
        random_alpha = "".join(random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ") for _ in range(3))
        sku = f"{dept_prefix}-{random_alpha}-{product_id:03d}"
        while sku in generated_skus:
            random_alpha = "".join(random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ") for _ in range(3))
            sku = f"{dept_prefix}-{random_alpha}-{product_id:03d}"
        generated_skus.add(sku)

        # Enforce strategic profit margin: 15% to 40% markup calculation
        cost_price = utils.generate_price(config.MIN_PRODUCT_PRICE, config.MAX_PRODUCT_PRICE)
        markup_percentage = random.uniform(0.15, 0.40)
        selling_price = round(cost_price * (1.0 + markup_percentage), 2)

        # Establish fixed inventory reorder alerts baseline
        reorder_level = 15

        # ==============================================================================
        # STRATEGIC LOW STOCK DEFICIT GENERATION
        # ==============================================================================
        # Intentionally force ~15% of products to fall completely below the reorder level
        if random.random() < 0.15:
            # Low stock state: values cluster strictly between 0 and 14 items
            current_stock_level = random.randint(0, reorder_level - 1)
        else:
            # Normal stock state: values range from 20 up to 250 items
            current_stock_level = random.randint(20, 250)

        record = {
            "Product_ID": product_id,
            "Product_Name": product_name,
            "SKU": sku,
            "Category_ID": category_id,
            "Supplier_ID": supplier_id,
            "Cost_Price": cost_price,
            "Selling_Price": selling_price,
            "Current_Stock_Level": current_stock_level,
            "Reorder_Level": reorder_level,
            "Status": random.choice(["Active", "Active", "Active", "Discontinued"])
        }
        records.append(record)

    # Export records to output directory via utility helper
    utils.export_to_csv(records, "products.csv")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_products_data()

