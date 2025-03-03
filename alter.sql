CREATE TABLE dogs (
    name VARCHAR(300),
    breed VARCHAR(300),
    color VARCHAR(300)
);

INSERT INTO dogs (name, breed, color) VALUES 
('Bark', 'None', 'Red'), 
('Doggi', 'Alabai', 'Black'), 
('Bark', 'None', 'Red');

ALTER TABLE dogs 
-- далі іде дія
ADD COLUMN id serial;

ALTER TABLE dogs
DROP COLUMN id;

ALTER TABLE dogs
ADD CONSTRAINT "dogs_pkey" PRIMARY KEY (id);

ALTER TABLE users
ADD COLUMN  gender VARCHAR(100);

ALTER TABLE users
DROP COLUMN user_password;

ALTER TABLE products
DROP COLUMN name;

DELETE FROM orders;