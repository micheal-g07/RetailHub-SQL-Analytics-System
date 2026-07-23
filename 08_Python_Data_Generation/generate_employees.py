"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Employees
==========================================
"""

import random
import pandas as pd
import os
import utils
import config

def generate_employees_data():
    """
    Generates exactly 80 detailed employee records with realistic gender-aligned names,
    and applies a round-robin distribution to allocate staff evenly across all stores.
    """
    # Load stores file to read real Store_IDs and their corresponding Opening_Dates
    stores_path = os.path.join(config.OUTPUT_DIR, "stores.csv")
    if not os.path.exists(stores_path):
        raise FileNotFoundError("stores.csv not found! Run generate_stores.py first.")
    
    stores_df = pd.read_csv(stores_path)
    store_info = stores_df.set_index("Store_ID")["Opening_Date"].to_dict()
    store_ids = list(store_info.keys())

    records = []
    employee_id = 1
    
    # Track unique emails and phones to strictly guarantee constraint compliance
    generated_emails = set()
    generated_phones = set()

    # ==============================================================================
    # STEP 1: MANDATORY PLACEMENT (1 STORE MANAGER PER STORE)
    # ==============================================================================
    for store_id in store_ids:
        if employee_id > config.NUM_EMPLOYEES:
            break
            
        # Select Gender and matching realistic names (Same approach as generate_customers.py)
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
        
        # Enforce Unique Corporate Email Generation
        email = utils.generate_email(full_name, company_suffix="retailhub")
        while email in generated_emails:
            email = utils.generate_email(f"{full_name}{random.randint(1,9)}", company_suffix="retailhub")
        generated_emails.add(email)
        
        # Enforce Unique Phone Generation
        phone = utils.generate_phone()
        while phone in generated_phones:
            phone = utils.generate_phone()
        generated_phones.add(phone)
        
        # Pick a random salary within the centrally configured range
        min_sal, max_sal = config.SALARY_RANGES["Store Manager"]
        salary = round(random.uniform(min_sal, max_sal), 2)
        
        # Chronological logic: Employee hire date must be ON or AFTER store opening date
        store_open_date = pd.to_datetime(store_info[store_id]).date()
        hire_date = utils.generate_date(start_date=store_open_date, end_date=config.END_DATE)
        
        record = {
            "Employee_ID": employee_id,
            "First_Name": first_name,
            "Last_Name": last_name,
            "Email": email,
            "Phone": phone,
            "Gender": gender,
            "Role": "Store Manager",
            "Salary": salary,
            "Hire_Date": hire_date,
            "Store_ID": store_id,
            "Status": "Active"
        }
        records.append(record)
        employee_id += 1

    # ==============================================================================
    # STEP 2: ROUND-ROBIN DISTRIBUTION FOR REMAINING FLOOR STAFF
    # ==============================================================================
    floor_staff_roles = ["Sales Associate", "Cashier", "Inventory Executive"]
    role_weights = [0.50, 0.30, 0.20] # 50% Sales, 30% Cashier, 20% Inventory

    # Infinite cyclical loop over store IDs to distribute remaining 65 vacancies perfectly
    store_index = 0
    
    while employee_id <= config.NUM_EMPLOYEES:
        # Pick store in sequential order rather than random choice
        store_id = store_ids[store_index]
        
        # Select floor staff role based on operational weights
        role = random.choices(floor_staff_roles, weights=role_weights, k=1)[0]
        
        # Select Gender and matching realistic names
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
        
        # Enforce Unique Corporate Email Generation
        email = utils.generate_email(full_name, company_suffix="retailhub")
        while email in generated_emails:
            email = utils.generate_email(f"{full_name}{random.randint(1,9)}", company_suffix="retailhub")
        generated_emails.add(email)
        
        # Enforce Unique Phone Generation
        phone = utils.generate_phone()
        while phone in generated_phones:
            phone = utils.generate_phone()
        generated_phones.add(phone)
        
        # Dynamic lookup from config dictionary parameters
        min_sal, max_sal = config.SALARY_RANGES[role]
        salary = round(random.uniform(min_sal, max_sal), 2)
        
        store_open_date = pd.to_datetime(store_info[store_id]).date()
        hire_date = utils.generate_date(start_date=store_open_date, end_date=config.END_DATE)
        
        record = {
            "Employee_ID": employee_id,
            "First_Name": first_name,
            "Last_Name": last_name,
            "Email": email,
            "Phone": phone,
            "Gender": gender,
            "Role": role,
            "Salary": salary,
            "Hire_Date": hire_date,
            "Store_ID": store_id,
            "Status": random.choice(["Active", "Active", "Active", "Inactive"]) # 75% active probability
        }
        records.append(record)
        
        # Increment pointers
        employee_id += 1
        store_index = (store_index + 1) % len(store_ids) # Loops back to index 0 after store 15

    # Export records to output directory via utility helper
    utils.export_to_csv(records, "employees.csv")

if __name__ == "__main__":
    utils.initialize_generator()
    generate_employees_data()



