"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Configuration
==========================================
"""

import os
import random
from datetime import date

# ==============================================================================
# REPRODUCIBILITY & LOCALE SETTINGS
# ==============================================================================

# Define a fixed seed for reproducible randomized data across runs
SEED = 42
random.seed(SEED)

# Localization configuration for Indian demographic data (Names, Addresses, Phones)
FAKER_LOCALE = "en_IN"

# ==============================================================================
# DATA VOLUME SETTINGS (ROW COUNTS)
# ==============================================================================

NUM_CATEGORIES = 10
NUM_SUPPLIERS = 20
NUM_STORES = 15
NUM_CUSTOMERS = 500
NUM_EMPLOYEES = 80
NUM_PRODUCTS = 250
NUM_ORDERS = 5000

# Average number of items per order shell to hitting the 12,000–15,000 range
MIN_ITEMS_PER_ORDER = 2
MAX_ITEMS_PER_ORDER = 3

# Percentage of line items returned (0.06 yields roughly 300-500 returns)
RETURN_RATE = 0.06

# ==============================================================================
# COMPENSATION STRUCTURES (Monthly INR)
# ==============================================================================
SALARY_RANGES = {
    "Store Manager": (65000.00, 90000.00),
    "Sales Associate": (25000.00, 40000.00),
    "Cashier": (22000.00, 35000.00),
    "Inventory Executive": (28000.00, 42000.00),
}

# ==============================================================================
# TEMPORAL & BUSINESS METRIC LIMITS
# ==============================================================================

# Operational timeline boundaries for transactions
START_DATE = date(2024, 1, 1)
END_DATE = date(2026, 6, 30)

# Financial and quantity ranges
MIN_PRODUCT_PRICE = 99.00     # ₹99.00 INR
MAX_PRODUCT_PRICE = 49999.00  # ₹49,999.00 INR
MIN_ITEM_QUANTITY = 1
MAX_ITEM_QUANTITY = 5

# ==============================================================================
# STORE OPERATIONAL HOURS (24-Hour Format)
# ==============================================================================
STORE_OPEN_HOUR = 9   # 09:00 AM
STORE_CLOSE_HOUR = 21 # 09:00 PM


# ==============================================================================
# ENVIRONMENT DATA PATHS
# ==============================================================================

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "generated_data")
os.makedirs(OUTPUT_DIR, exist_ok=True)
