"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Generate Suppliers
==========================================
"""

import utils
import config

def generate_suppliers_data():
    """
    Generates exactly 20 unique commercial supplier profiles with localized
    Indian geographic details, contact parameters, and clean data attributes.
    """
    records = []
    
    # Track unique emails and phones to strictly guarantee constraint compliance
    generated_emails = set()
    generated_phones = set()
    
    for supplier_id in range(1, config.NUM_SUPPLIERS + 1):
        # Generate a realistic corporate vendor name using Faker
        company_name = f"{utils.fake.company()} {utils.fake.company_suffix()}"
        contact_person = utils.fake.name()
        
        # Ensure unique email generation loop
        email = utils.generate_email(company_name, company_suffix="vendor")
        while email in generated_emails:
            email = utils.generate_email(company_name, company_suffix="vendor")
        generated_emails.add(email)
        
        # Ensure unique 10-digit Indian phone generation loop
        phone = utils.generate_phone()
        while phone in generated_phones:
            phone = utils.generate_phone()
        generated_phones.add(phone)
        
        # Fetch valid Indian city and state parameters
        city = utils.fake.city()
        state = utils.fake.state()
        
        record = {
            "Supplier_ID": supplier_id,
            "Supplier_Name": company_name,
            "Contact_Name": contact_person,
            "Email": email,
            "Phone": phone,
            "City": city,
            "State": state
        }
        records.append(record)
        
    # Export records to output directory via utility helper
    utils.export_to_csv(records, "suppliers.csv")

if __name__ == "__main__":
    # Ensure reproducibility configuration is loaded before processing
    utils.initialize_generator()
    generate_suppliers_data()
