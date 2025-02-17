/* Умовні конструкції */

/*

Синтаксис 1:

CASE
    WHEN (умова1) THEN результат1
    WHEN (умова2) THEN результат2
    WHEN (умова3) THEN результат3
    ELSE
        результат 4
END

CASE (умова)
    WHEN (значення1) THEN результат1
    WHEN (значення2) THEN результат2
    WHEN (значення3) THEN результат3
    ELSE результат4    
END

*/

-- Витягти всіх юзерів з їхньою кількістю замовлень

SELECT u.*, count(*) AS order_count
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;

-- Якщо у юзера > 3 замовлень, то він "постійний клієнт", якщо від 1 до 3 - клієнт, якщо 0 - новий клієнт

SELECT u.id, u.email, (
    CASE 
        WHEN count(o.id) > 3 THEN 'regular client'
        WHEN count(o.id) BETWEEN 1 AND 3 THEN 'client'
        ELSE 'new client'
    END
) AS "client_status"
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id
ORDER BY count(o.id) ASC;

--- Вивести всі телефони з їхньою вартістю. Зробити новий стовбець "бюджет" - якщо телефон дорожче ніж середня вартість телефонів на складі - вивести "дорогий", якщо дешевше - вивести "дешевий"

SELECT id, model, brand, price
FROM products;

-- середня вартість

SELECT avg(price)
FROM products; --5126.88

WITH avg_price AS (
    SELECT avg(price) AS ap
    FROM products
)
SELECT  id, model, brand, price, (
    CASE
        WHEN price > avg_price.ap THEN 'high'
        ELSE 'low'
    END
) AS budget
FROM products, avg_price;

/*
WITH temporaryTable(averageValue) as (
  SELECT avg(price) FROM products
)
SELECT products.price, (CASE
WHEN products.price>temporaryTable.averageValue THEN 'expensive'
ELSE 'chip'
END) as budget
FROM products, temporaryTable

*/

---- Кастомні типи даних ----

--- Задача: переробити стовбець "статус" таблиці orders з boolean на перераховувану множину
'new', 'processing', 'delivery', 'done'
-- ENUM - enumerable, перераховувана множина

DROP TYPE status;
DROP TABLE c;

CREATE TYPE order_status AS ENUM ('new',
'processing', 'delivery', 'done');

CREATE TABLE c (
    id serial PRIMARY KEY,
    info status
);

ALTER TABLE orders
ALTER COLUMN status TYPE order_status USING (
        CASE status
            WHEN false THEN 'new'
            WHEN true THEN 'done'
            ELSE 'processing'
        END
)::order_status; --- стається помилка через те, що дефолтне значення стовпця неможна автоматично конвертувати

--- Рішення:
-- дропнути дефолт
-- змінити таблицю (кастувати автоматично по ходу)
-- створити нове дефолтне правило для таблиці

ALTER TABLE orders
ALTER COLUMN status DROP DEFAULT;


INSERT INTO orders (customer_id, status)
VALUES (2,
    'delivery');

ALTER TABLE orders
ALTER COLUMN status SET DEFAULT 'new';

---- Views - Віртуальні таблиці ----

/* 
Views - представлення - віртуальні таблиці
Фізично цих табличних виразів не існує
*/

-- Задача - мати таблицю юзерів з кількістю їхніх замовлень

SELECT u.*, count(o.id) AS "order_count"
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;

--- Створення View
CREATE VIEW users_with_orders_amount AS (
    SELECT u.*, count(o.id) AS "order_count"
    FROM users AS u 
    LEFT JOIN orders AS o 
    ON u.id = o.customer_id
    GROUP BY u.id
);

-- Використання view

SELECT * FROM users_with_orders_amount
ORDER BY id;

SELECT * FROM users_with_orders_amount
WHERE order_count >= 3;

UPDATE users
SET first_name = 'Alex'
WHERE id = 60;

--- всі замовлення разом з їхньою вартістю

SELECT o.*, sum(p.price * otp.quantity) AS order_sum
FROM orders AS o 
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY o.id;

-- Всі замовлення конкретного користувача
-- Всі замовлення сумою вище ніж
-- Всі замовлення, створені за певної дати

CREATE VIEW orders_with_cash_amounts AS (
   SELECT o.*, sum(p.price * otp.quantity) AS order_sum
    FROM orders AS o 
    JOIN orders_to_products AS otp
    ON o.id = otp.order_id
    JOIN products AS p 
    ON otp.product_id = p.id
    GROUP BY o.id
);

-- Всі замовлення конкретного користувача

SELECT * FROM orders_with_cash_amounts
WHERE customer_id = 60;

CREATE VIEW spam_list AS (
    SELECT customer_id FROM orders_with_cash_amounts
    WHERE order_sum > 20000
);

/*
Створити view:

1. Топ-10 найдорожчих замовлень

2. Топ-10 юзерів з найбільшою кількістю замовлень

*/

SELECT *
FROM orders_with_cash_amounts
ORDER BY order_sum DESC
LIMIT 10;

CREATE VIEW top10_expensive_orders AS (
    SELECT * 
    FROM orders_with_cash_amounts
    ORDER BY order_sum DESC
    LIMIT 10);

---2

SELECT * FROM users_with_orders_amount
ORDER BY order_count DESC
LIMIT 10;

CREATE VIEW top10_order_users AS (
    SELECT * 
    FROM orders_with_cash_amounts
    ORDER BY order_sum DESC
    LIMIT 10
);

--- Перестворити вью

--1
DROP VIEW top10_expensive_orders;
DROP VIEW spam_list;
DROP VIEW orders_with_cash_amounts;

--2

CREATE OR REPLACE VIEW orders_with_cash_amounts AS (
   SELECT o.*, sum(p.price * otp.quantity) AS order_sum
    FROM orders AS o 
    LEFT JOIN orders_to_products AS otp
    ON o.id = otp.order_id
    LEFT JOIN products AS p 
    ON otp.product_id = p.id
    GROUP BY o.id
);

SELECT o.*, sum(p.price * otp.quantity) AS order_sum
    FROM orders AS o 
    LEFT JOIN orders_to_products AS otp
    ON o.id = otp.order_id
    LEFT JOIN products AS p 
    ON otp.product_id = p.id
    GROUP BY o.id
    ORDER BY o.id DESC;

DELETE FROM orders
    WHERE id = 1279;

SELECT * FROM orders_to_products AS otp
WHERE product_id IS NULL;

SELECT *
FROM orders_to_products AS otp
FULL JOIN products AS p
ON otp.product_id = p.id
WHERE otp.product_id IS NULL; --Catch it!

-- Задача: зробити вью з всіма юзерами і повною сумою грошей, які юзери залишили в нашому магазині

SELECT u.*, sum(order_sum) 
FROM users AS u
JOIN orders_with_cash_amounts AS owca 
ON u.id = owca.customer_id
GROUP BY u.id;

CREATE VIEW users_with_full_order_sum AS (
    SELECT u.*, sum(order_sum) 
    FROM users AS u
    JOIN orders_with_cash_amounts AS owca 
    ON u.id = owca.customer_id
    GROUP BY u.id
);

SELECT * FROM users_with_full_order_sum
ORDER BY sum DESC
LIMIT 10;