"""Crea la base de datos de práctica de e-commerce para entrenar SQL analítico."""
import sqlite3
import random
from datetime import datetime, timedelta

conn = sqlite3.connect("ecommerce_practice.db")
c = conn.cursor()

# --- Schema ---
c.executescript("""
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT,
    state TEXT,
    signup_date TEXT
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    price REAL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TEXT,
    status TEXT,  -- 'delivered', 'shipped', 'cancelled'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    unit_price REAL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
""")

# --- Datos de prueba ---
random.seed(42)

estados = ["SP", "RJ", "MG", "BA", "RS", "PR", "SC", "PE", "CE", "GO"]
categorias = ["electronics", "furniture", "clothing", "food", "books", "toys"]
nombres = [f"Cliente_{i}" for i in range(1, 101)]

# Customers
for i in range(1, 101):
    c.execute(
        "INSERT INTO customers VALUES (?, ?, ?, ?)",
        (i, random.choice(nombres), random.choice(estados),
         f"2023-{random.randint(1,12):02d}-{random.randint(1,28):02d}")
    )

# Products
for i in range(1, 21):
    cat = random.choice(categorias)
    precio = round(random.uniform(10, 500), 2)
    c.execute(
        "INSERT INTO products VALUES (?, ?, ?, ?)",
        (i, f"Producto_{i}", cat, precio)
    )

# Orders (algunos clientes repiten = simula retención)
statuses = ["delivered"] * 70 + ["shipped"] * 20 + ["cancelled"] * 10
base_date = datetime(2024, 1, 1)
order_id = 1
for _ in range(200):
    cust_id = random.choices(range(1, 101), weights=[random.randint(1, 5) for _ in range(100)])[0]
    fecha = base_date + timedelta(days=random.randint(0, 365))
    status = random.choice(statuses)
    c.execute(
        "INSERT INTO orders VALUES (?, ?, ?, ?)",
        (order_id, cust_id, fecha.strftime("%Y-%m-%d"), status)
    )
    # 1-3 items por order
    for _ in range(random.randint(1, 3)):
        prod_id = random.randint(1, 20)
        qty = random.randint(1, 5)
        unit_price = round(random.uniform(10, 500), 2)
        c.execute(
            "INSERT INTO order_items VALUES (?, ?, ?, ?, ?)",
            (order_id * 10 + _, order_id, prod_id, qty, unit_price)
        )
    order_id += 1

conn.commit()
conn.close()
print("Base de datos creada: ecommerce_practice.db")
print(f"  - 100 clientes")
print(f"  - 20 productos")
print(f"  - 200 órdenes")
print(f"  - ~400 items")
