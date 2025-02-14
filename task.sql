CREATE TABLE products (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    price numeric(16, 2) CHECK (price > 0)
);

CREATE TABLE clients (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    address text,
    phone_number varchar(16)
);

CREATE TABLE contracts (
    id serial PRIMARY KEY,
    created_at date CHECK(created_at <current_date)
);

CREATE TABLE orders (
    id serial PRIMARY KEY,
    client_id int REFERENCES clients(id),
    contract_id int REFERENCES contracts(id),
    product_id int REFERENCES products(id),
    quantity_plan int NOT NULL CHECK (quantity_plan > 0)
);

CREATE TABLE shipments (
    id serial PRIMARY KEY,
    ship_date date CHECK (ship_date <= currrent_date)
);

CREATE TABLE shipments_to_orders (
    shipment_id int REFERENCES shipments(id),
    order_id int REFERENCES orders(id),
    quantity int NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (shipment_id, order_id)
);