"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Utils
==========================================
"""

import random
import os
import pandas as pd
from datetime import timedelta
from faker import Faker
import config

# Initialize localized Faker instance using configuration profile
fake = Faker(config.FAKER_LOCALE)

def initialize_generator():
    """Enforces random seeds across random and Faker for 100% reproducibility."""
    random.seed(config.SEED)
    Faker.seed(config.SEED)

# ==============================================================================
# REUSABLE DATA GENERATION FUNCTIONS
# ==============================================================================

def generate_phone():
    """
    Generates a realistic 10-digit Indian mobile number format.
    Starts with 6, 7, 8, or 9 per Indian telecom standards.
    """
    first_digit = random.choice(['6', '7', '8', '9'])
    remaining_digits = "".join(str(random.randint(0, 9)) for _ in range(9))
    return f"{first_digit}{remaining_digits}"

def generate_email(name_string, company_suffix="retailhub"):
    """
    Generates a realistic email address with an appended 2-digit number.
    Scrubs special characters and spaces from the input name string.
    """
    clean_name = "".join(e for e in name_string.lower() if e.isalnum())
    random_suffix = random.randint(10, 99)
    domain = random.choice([f"{company_suffix}.in", "gmail.com", "yahoo.co.in", "outlook.com"])
    return f"{clean_name}{random_suffix}@{domain}"

def generate_date(start_date=config.START_DATE, end_date=config.END_DATE):
    """Generates a random date between operational boundaries for MySQL (YYYY-MM-DD)."""
    delta_days = (end_date - start_date).days
    random_days = random.randint(0, delta_days)
    return start_date + timedelta(days=random_days)

def generate_price(min_p=config.MIN_PRODUCT_PRICE, max_p=config.MAX_PRODUCT_PRICE):
    """Generates a rounded commercial decimal price for product models."""
    return round(random.uniform(min_p, max_p), 2)

def generate_quantity(min_q=config.MIN_ITEM_QUANTITY, max_q=config.MAX_ITEM_QUANTITY):
    """Generates a random integer representing customer purchase line counts."""
    return random.randint(min_q, max_q)

# ==============================================================================
# EXPORT & STORAGE LAYER HELPERS
# ==============================================================================

def export_to_csv(data_records, filename):
    """Converts a dictionary list to a structured DataFrame and exports to folder."""
    df = pd.DataFrame(data_records)
    destination_path = os.path.join(config.OUTPUT_DIR, filename)
    df.to_csv(destination_path, index=False)
    print(f"📦 Written: {filename:<20} | Rows: {len(df)}")
    return df


