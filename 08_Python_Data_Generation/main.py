"""
==========================================
Project : RetailHub Sales Analytics System
Author  : Micheal
Task    : Master Orchestrator
==========================================
"""


import time
import utils

# Import all individual generation modules
import generate_categories
import generate_suppliers
import generate_stores
import generate_customers
import generate_employees
import generate_products
import generate_orders
import generate_order_items
import generate_payments
import generate_returns

def main():
    """
    Main orchestration engine. Executes all dataset generators in a strict
    sequential order to guarantee flawless database referential integrity.
    """
    print("=" * 65)
    print("STARTING RETAILHUB SYNTHETIC DATA GENERATION PIPELINE")
    print("=" * 65)
    
    start_time = time.time()
    
    # 1. Initialize random seeds for 100% reproducibility
    utils.initialize_generator()
    print("Reproducibility seeds locked. Global context initialized.\n")

    # 2. Strict Chronological Generation Sequence
    print("--- [LEVEL 1: BASE DIMENSION PARENTS] ---")
    generate_categories.generate_categories_data()
    generate_suppliers.generate_suppliers_data()
    generate_stores.generate_stores_data()
    generate_customers.generate_customers_data()
    print()

    print("--- [LEVEL 2: DEPENDENT COMPONENT TABLES] ---")
    generate_employees.generate_employees_data()
    generate_products.generate_products_data()
    print()

    print("--- [LEVEL 3: TRANSACTION SHELLS] ---")
    generate_orders.generate_orders_data()
    print()

    print("--- [LEVEL 4: TRANSACTION DETAILS & LEDGERS] ---")
    generate_order_items.generate_order_items_data()
    generate_payments.generate_payments_data()
    generate_returns.generate_returns_data()
    print()

    # 3. Print Final Execution Statistics
    elapsed_time = round(time.time() - start_time, 2)
    print("=" * 65)
    print(f"PIPELINE COMPLETED SUCCESSFULLY IN {elapsed_time} SECONDS")
    print("Check your '/generated_data' directory for the generated data.")
    print("=" * 65)

if __name__ == "__main__":
    main()
