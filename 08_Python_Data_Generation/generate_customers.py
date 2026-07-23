"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Customers
==========================================
"""

import random
import utils
import config
from datetime import date, timedelta

def generate_customers_data():
    """
    Generates exactly 500 detailed customer records mapping Indian buyer personas,
    with registration dates intentionally spread across 3 historic tiers for future analytics.
    """
    records = []
    
    # Track unique emails and phones to strictly guarantee constraint compliance
    generated_emails = set()
    generated_phones = set()
    
    # ==============================================================================
    # TIME BUCKET CONFIGURATION FOR COHORT ANALYSIS
    # ==============================================================================
    # Divide the project operational timeline (Jan 2024 to June 2026) into 3 eras:
    total_days = (config.END_DATE - config.START_DATE).days
    one_third_days = total_days // 3
    
    tier_boundaries = {
        "Long-Term (Tier 1)": (config.START_DATE, config.START_DATE + timedelta(days=one_third_days)),
        "Mid-Term (Tier 2)": (config.START_DATE + timedelta(days=one_third_days + 1), config.START_DATE + timedelta(days=one_third_days * 2)),
        "Newer (Tier 3)": (config.START_DATE + timedelta(days=(one_third_days * 2) + 1), config.END_DATE)
    }
    
    # Establish a realistic distribution weight (e.g., 25% Early Adopters, 40% Growth Phase, 35% Recent signups)
    tier_pool = ["Long-Term (Tier 1)", "Mid-Term (Tier 2)", "Newer (Tier 3)"]
    tier_weights = [0.25, 0.40, 0.35]

    for customer_id in range(1, config.NUM_CUSTOMERS + 1):
        # Pick a structured gender profile to match first names realistically
        gender = random.choice(['Male', 'Female', 'Other'])
        
        if gender == 'Male':
            first_name = utils.fake.first_name_male()
            last_name = utils.fake.last_name_male()
        elif gender == 'Female':
            first_name = utils.fake.first_name_female()
            last_name = utils.fake.last_name_female()
        else:
            first_name = utils.fake.first_name()
            last_name = utils.fake.last_name()
            
        full_name = f"{first_name}{last_name}"
        
        # Enforce unique email generation
        email = utils.generate_email(full_name, company_suffix="shopper")
        while email in generated_emails:
            email = utils.generate_email(f"{full_name}{random.randint(1,9)}", company_suffix="shopper")
        generated_emails.add(email)
        
        # Enforce unique phone generation 
        phone = utils.generate_phone()
        while phone in generated_phones:
            phone = utils.generate_phone()
        generated_phones.add(phone)
        
        # Generate demographic constraints (DOB limits: Age 18 to 70)
        dob = utils.fake.date_of_birth(minimum_age=18, maximum_age=70)
        
        city = utils.fake.city()
        state = utils.fake.state()
        
        # Select chronological signup date based on our target analysis weights
        selected_tier = random.choices(tier_pool, weights=tier_weights, k=1)[0]
        start_bound, end_bound = tier_boundaries[selected_tier]
        registration_date = utils.generate_date(start_date=start_bound, end_date=end_bound)
        
        record = {
            "Customer_ID": customer_id,
            "First_Name": first_name,
            "Last_Name": last_name,
            "Email": email,
            "Phone": phone,
            "Gender": gender,
            "Date_of_Birth": dob,
            "City": city,
            "State": state,
            "Registration_Date": registration_date
        }
        records.append(record)
        
    # Export records to output directory via utility helper
    utils.export_to_csv(records, "customers.csv")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_customers_data()

