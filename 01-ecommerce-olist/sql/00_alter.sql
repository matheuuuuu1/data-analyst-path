ALTER TABLE orders
ADD PRIMARY KEY (order_id);
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);
ALTER TABLE products
ADD PRIMARY KEY (product_id);
ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

ALTER TABLE order_reviews
ADD CONSTRAINT fk_orders_reviews
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);


ALTER TABLE order_payments
ADD CONSTRAINT fk_orders_payments
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);