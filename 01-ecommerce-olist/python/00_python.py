from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

print('------------------')
print('Creando motor')
print('------------------')
engine = create_engine("postgresql://analyst:analyst123@localhost:5432/olist")

# VIEWS
print('------------------')
print('Asignando vistas')
print('------------------')

category_rank = pd.read_sql('vw_category_rank', engine)
items_rank = pd.read_sql('vw_items_rank', engine)
earnings_day = pd.read_sql('vw_orders_earnings', engine)
earnings_day = earnings_day[earnings_day['date'] < '2018-09']
earnings_month = pd.read_sql('vw_orders_earnings_month', engine)
earnings_month = earnings_month[earnings_month['date'] < '2018-09']
ticket = pd.read_sql('vw_ticket_region', engine)
delivery = pd.read_sql('vw_delivery_performance', engine)
cohort = pd.read_sql('vw_cohort', engine)

# RAW
print('------------------')
print('Asignando Raws')
print('------------------')

orders = pd.read_sql('SELECT * FROM orders', engine)
customers = pd.read_sql('SELECT * FROM customers', engine)
order_items = pd.read_sql('SELECT * FROM order_items', engine)
products = pd.read_sql('SELECT * FROM products', engine)

print('------------------')
print('Verificacion de Nulos en Cada Tabla')
print('--- Orders ---')
print(orders.isnull().sum())
print('--- Customers ---')
print(customers.isnull().sum())
print('--- Products ---')
print(products.isnull().sum())
print('--- Order Items ---')
print(order_items.isnull().sum())

print("""La razón por la que no se eliminan los nulos de Products y Orders 
es que los nulos que tiene realmente no afectan a ningun procedimiento de analisis
en ningun aspecto del EDA""")
print('--- Acá se ve ---')
print(orders[orders['order_delivered_customer_date'].isnull()]['order_status'].value_counts())
print('--- Ese es el estado de cada producto con registros nulos en fechas, no es necesario eliminarlos ---')

print('--- Descripción de Orders, Columnas Numéricas ---')
print(orders.describe().T)

print('--- Heatmap de Cohort ---')
cohort_pivot = cohort.pivot(index='cohort_month', columns='months_since_first', values='num_customers')
# Retención
retention = cohort_pivot.divide(cohort_pivot.iloc[:, 0], axis=0) * 100
# Heatmap
plt.figure(figsize=(16, 10))
plt.title('Tasa de Retención por Cohort')
plt.imshow(retention, cmap='YlGnBu', aspect='auto')
plt.xticks(range(len(retention.columns)), retention.columns.astype(int))
plt.yticks(range(len(retention.index)), retention.index)
plt.colorbar(label='% Retención')
plt.xlabel('Meses desde primera compra')
plt.ylabel('Cohort')
plt.tight_layout()
plt.savefig('cohort_heatmap.png')
plt.show()

# Histograma
print('--- Histograma de Ingresos Mensuales ---')
plt.figure(figsize=(10, 6))
plt.plot(earnings_month['date'], earnings_month['ingresos'])
plt.title('Ingresos Mensuales')
plt.xlabel('Fecha')
plt.xticks(rotation=45, ha='right')
plt.ylabel('Ingresos ($)')
plt.grid(True) # Agrega cuadrícula de fondo
plt.savefig('ingresos_mensuales.png')
plt.show()

print('--- Categorías por Ingresos ---')
print('--- Vertical Bar Chart ---')
top10 = category_rank.head(10)
plt.figure(figsize=(12, 8))
plt.bar(top10['category'], top10['earnings'])
plt.title('Clasificacion de Categorías')
plt.xlabel('Categoria')
plt.xticks(rotation=60, ha='right')
plt.ylabel('Earnings')
plt.grid(True)
plt.savefig('clasificacion_categorias.png')
plt.show()

print('--- Ticket / Region ---')
top10_t = ticket.head(10)
plt.figure(figsize=(12, 6))
plt.barh(top10_t['state'], top10_t['ticket'])
plt.xlabel('Ticket')
plt.xticks(rotation=60, ha='right')
plt.ylabel('Region')
plt.savefig('ticket_region.png')
plt.show()

print('--- Delivery Performance ---')
plt.figure(figsize=(10,10))
plt.pie(delivery['pct_title'], labels=delivery['title'], autopct='%1.1f%%', startangle=90)
plt.title('Delivery Performance')
plt.savefig('delivery.png')
plt.show()
# plt.savefig('mi_grafico.png') # Descomenta para guardar como imagen
