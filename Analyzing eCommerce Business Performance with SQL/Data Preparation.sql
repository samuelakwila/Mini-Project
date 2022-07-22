--- CREATE TABLE

CREATE TABLE customers_dataset (
	customer_id varchar(250),
	customer_unique_id varchar(250),
	customer_zip_code_prefix int,
	customer_city varchar(250),
	customer_state varchar(250)
);

CREATE TABLE geolocation_dataset (
	geolocation_zip_code_prefix varchar(250),
	geolocation_lat varchar(250),
	geolocation_lng varchar(250),
	geolocation_city varchar(250),
	geolocation_state varchar(250)
);

CREATE TABLE order_items_dataset (
	order_id varchar(250),
	order_item_id int,
	product_id varchar(250),
	seller_id varchar(250),
	shipping_limit_date timestamp,
	price float,
	freight_value float
);

CREATE TABLE order_payments_dataset (
	order_id varchar(250),
	payment_sequential int,
	payment_type varchar(250),
	payment_installments int,
	payment_value float
);


CREATE TABLE order_reviews_dataset (
	review_id varchar(250),
	order_id varchar(250),
	review_score int, 
	review_comment_title varchar(250),
	review_comment_message text,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);

CREATE TABLE orders_dataset (
	order_id varchar(250),
	customer_id varchar(250),
	order_status varchar(250),
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
);

CREATE TABLE product_dataset (
	product_id varchar(250),
	product_category_name varchar(250),
	product_name_lenght int,
	product_description_lenght int,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);

CREATE TABLE sellers_dataset (
	seller_id varchar(250),
	seller_zip_code_prefix int,
	seller_city varchar(250),
	seller_state varchar(250)
);


--- ENTITY RELATIONSHIP DIAGRAM (ERD)
ALTER TABLE product_dataset
	ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

ALTER TABLE order_items_dataset
	ADD FOREIGN KEY (product_id) REFERENCES product_dataset;

ALTER TABLE customers_dataset
	ADD CONSTRAINT pk_cust PRIMARY KEY (customer_id);

ALTER TABLE geolocation_dataset
	ADD CONSTRAINT pk_geo PRIMARY KEY (geolocation_zip_code_prefix);

ALTER TABLE orders_dataset
	ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);

ALTER TABLE sellers_dataset
	ADD CONSTRAINT pk_seller PRIMARY KEY (seller_id);

ALTER TABLE customers_dataset
	ADD FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset;

ALTER TABLE orders
	ADD FOREIGN KEY (customer_id) REFERENCES customers_dataset;

ALTER TABLE order_items
	ADD FOREIGN KEY (order_id) REFERENCES orders_datasee;

ALTER TABLE order_items
	ADD FOREIGN KEY (seller_id) REFERENCES sellers_dataset;

ALTER TABLE sellers
	ADD FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation_dataset;

ALTER TABLE payments
	ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;

ALTER TABLE order_items
	ADD FOREIGN KEY (product_id) REFERENCES product_dataset;

ALTER TABLE reviews
	ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
