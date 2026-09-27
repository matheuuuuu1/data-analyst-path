"""
Carga los CSVs de Olist a PostgreSQL.
Uso: python3 load_to_postgres.py
"""
import pandas as pd
from sqlalchemy import create_engine

DB_URL = "postgresql://analyst:analyst123@localhost:5432/olist"
DATA_DIR = "."

TABLES = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation",
}

def main():
    engine = create_engine(DB_URL)

    for file, table in TABLES.items():
        path = f"{DATA_DIR}/{file}"
        print(f"Cargando {file} → {table}...", end=" ")
        try:
            df = pd.read_csv(path)
            df.to_sql(table, engine, if_exists="replace", index=False)
            print(f"✓ ({len(df)} filas)")
        except Exception as e:
            print(f"✗ Error: {e}")

    print("\nListo. Todas las tablas cargadas.")

if __name__ == "__main__":
    main()
