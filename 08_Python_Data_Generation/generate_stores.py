"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Stores
==========================================
"""

import utils
import config

def generate_stores_data():
    """
    Generates exactly 15 fixed, realistic physical retail branch profiles 
    across major Indian commercial hubs with clean operational opening dates.
    """
    # Define the precise, fixed store profiles with consistent naming conventions
    fixed_stores = [
        {"Store_Name": "RetailHub Mumbai Central", "City": "Mumbai", "State": "Maharashtra"},
        {"Store_Name": "RetailHub Bengaluru North", "City": "Bengaluru", "State": "Karnataka"},
        {"Store_Name": "RetailHub Chennai Express", "City": "Chennai", "State": "Tamil Nadu"},
        {"Store_Name": "RetailHub Hyderabad Tech Park", "City": "Hyderabad", "State": "Telangana"},
        {"Store_Name": "RetailHub Delhi Connaught Place", "City": "Delhi", "State": "Delhi"},
        {"Store_Name": "RetailHub Kolkata Salt Lake", "City": "Kolkata", "State": "West Bengal"},
        {"Store_Name": "RetailHub Pune Koregaon Park", "City": "Pune", "State": "Maharashtra"},
        {"Store_Name": "RetailHub Ahmedabad SG Highway", "City": "Ahmedabad", "State": "Gujarat"},
        {"Store_Name": "RetailHub Kochi Marine Drive", "City": "Kochi", "State": "Kerala"},
        {"Store_Name": "RetailHub Jaipur Pink City", "City": "Jaipur", "State": "Rajasthan"},
        {"Store_Name": "RetailHub Lucknow Hazratganj", "City": "Lucknow", "State": "Uttar Pradesh"},
        {"Store_Name": "RetailHub Chandigarh Sector 17", "City": "Chandigarh", "State": "Chandigarh"},
        {"Store_Name": "RetailHub Indore Vijay Nagar", "City": "Indore", "State": "Madhya Pradesh"},
        {"Store_Name": "RetailHub Gurugram Cyber City", "City": "Gurugram", "State": "Haryana"},
        {"Store_Name": "RetailHub Bhubaneswar Master Canteen", "City": "Bhubaneswar", "State": "Odisha"}
    ]
    
    records = []
    
    # Loop over the fixed list to construct structural database rows up to NUM_STORES
    for index, store_profile in enumerate(fixed_stores[:config.NUM_STORES], start=1):
        # Generate a launch timeline date within operational boundaries
        opening_date = utils.generate_date()
        
        record = {
            "Store_ID": index,
            "Store_Name": store_profile["Store_Name"],
            "City": store_profile["City"],
            "State": store_profile["State"],
            "Opening_Date": opening_date
        }
        records.append(record)
        
    # Export records to output directory via utility helper
    utils.export_to_csv(records, "stores.csv")

if __name__ == "__main__":
    # Ensure reproducibility configuration is loaded before processing
    utils.initialize_generator()
    generate_stores_data()

