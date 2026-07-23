"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Categories
==========================================
"""

import utils
import config

def generate_categories_data():
    """
    Generates a fixed list of 10 realistic retail business categories 
    with detailed text descriptions, exporting them directly to CSV.
    """
    # Map each fixed category to a realistic retail business description
    fixed_categories = {
        "Electronics": "Smartphones, laptops, tablets, and consumer audio-visual equipment.",
        "Home Appliances": "Refrigerators, washing machines, microwaves, and small kitchen appliances.",
        "Furniture": "Living room sofas, dining tables, office chairs, and bedroom setups.",
        "Clothing": "Men, women, and kids apparel including casual, formal, and ethnic wear.",
        "Footwear": "Athletic shoes, formal leather footwear, sneakers, and daily sandals.",
        "Beauty & Personal Care": "Skincare, cosmetics, hair care products, and personal hygiene essentials.",
        "Sports & Fitness": "Gym equipment, activewear, sports gear, and outdoor tracking accessories.",
        "Toys & Games": "Educational toys, board games, action figures, and puzzles for all ages.",
        "Groceries": "Fresh produce, daily dairy, pantry staples, beverages, and packaged snacks.",
        "Books & Stationery": "Academic textbooks, fiction novels, office supplies, and art materials."
    }
    
    records = []
    
    # Loop over the dictionary to construct the correct structural database rows
    for index, (category_name, description) in enumerate(fixed_categories.items(), start=1):
        record = {
            "Category_ID": index,
            "Category_Name": category_name,
            "Description": description
        }
        records.append(record)
        
    # Export records to output directory via utility helper
    utils.export_to_csv(records, "categories.csv")

if __name__ == "__main__":
    # Ensure reproducibility configuration is loaded before processing
    utils.initialize_generator()
    generate_categories_data()

