CREATE TABLE a (
    v char(3),
    t int
);

CREATE TABLE b (
    v char(3)
);

INSERT INTO a VALUES 
('XXX', 1),
('XXY', 1),
('XXZ', 1),
('XYX', 2),
('XYY', 2),
('XYZ', 2),
('YXX', 3),
('YXY', 3),
('YZX', 3);

INSERT INTO b VALUES
('ZXX'), ('XXX'), ('ZXZ'), ('YZX'), ('YXY');

SELECT * FROM a;

SELECT * FROM b;

SELECT * FROM a, b;

/*

Операції над множинами:

1. Декартів добуток - перемноження множин - це пари, 
які утворюються співставленням кожного елемента множини А 
до кожного елемента множини В

2. Об'єднання - елементи множини А + елементи множини В,
 а ті що зустрічаються і там, і там - в єдиному екземплярі

3. Перетин множин - це тільки ті елементи множин А і В, 
які зустрічаються і там, і там

4. Віднімання

A мінус В - всі елементи множини А мінус ті, 
які зустрічаються у множині В

В мінус А - всі елементи множини В мінус ті,
 які зустрічаються у множині А

Комутативна операція (від зміни місць доданок сума не змінюється) - 
операція, в якій всі операнди не мають особливого місця в операції
*/

--- Об'єднання

SELECT v FROM a
UNION
SELECT * FROM b; -- унікальні з а + унікальні з в, а ті що зустрічаються і там, і там - в 1 єкземплярі

--- Перетин

SELECT v FROM a
INTERSECT
SELECT * FROM b; -- значення з обох таблиць, які є і в одній, і в іншій

--- Віднімання

-- А мінус В

SELECT v FROM a
EXCEPT
SELECT * FROM b;

--- В мінус А 

SELECT * FROM b
EXCEPT 
SELECt v FROM a;
-----

SELECT * FROM users
ORDER BY id DESC;

--- Задача: знайти користувачів, які РОБИЛИ замовлення

SELECT id FROM users
INTERSECT
SELECT customer_id FROM orders;

--- Задача: знайти id користувачів, які не робили замовлень

SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders;--- Як отримати їхні імена та мейли?

--- Всі замовлення юзера №2


SELECT * FROM orders
WHERE customer_id = 2;

SELECT * FROM users
WHERE id = 2;

-- Вибірка - це операція відфільтровування множини за певною умовою (предикатом)

-- З'єднання (співставлення) множин:
-- декартовий добуток + вибірка даних

SELECT * FROM a, b
WHERE A.v = B.v;

SELECT A.v AS "id",
    A.t AS "price",
    B.v AS "phone_id"
FROM a, b
WHERE A.v = B.v;

-- JOIN

SELECT *
FROM a JOIN b
ON A.v = B.v;

--- JOIN - ключове слово для операції співставлення таблиць

-- ON - частина оператора JOIN, після нього йде умова вибірки з декартового добутку

-- частіше за все ця умова - співставлення Primary Key = Foreign Key

SELECT * 
FROM users JOIN orders
ON orders.customer_id = users.id
WHERE users.id = 2;

-- Таска: знайти всі замовлення юзерів з 3 по 5

SELECT * 
FROM users JOIN orders
ON orders.customer_id = users.id
WHERE users.id BETWEEN 3 AND 5;
---

SELECT * 
FROM  users JOIN orders
ON orders.customer_id = users.id;


--- Задача: витягти інформацію про юзерів та кількість їхніх замовлень

-- Кількість замовлень кожного юзера
SELECT count(*), customer_id
FROM orders
GROUP BY customer_id;


-- Всі юзери з кількістю їхніх замовлень
SELECT users.id, first_name, last_name, email, count(*) AS order_count 
FROM users JOIN orders
ON users.id = orders.customer_id
GROUP BY users.id;

--- 

-- Всі замовлення юзера #3 і ті телефони, які він замовив

SELECT * FROM users
WHERE id = 3;

SELECT * FROM orders
WHERE customer_id = 3; -- ми дізнались, що він зробив замовлення №6

SELECT * FROM orders_to_products
WHERE order_id = 6; -- ми дізнались, що в цьому замовленні було замовлено 4 екземпляри продукту №113 і 3 екземпляри продукту №203

SELECT * 
FROM users JOIN orders
ON users.id = orders.customer_id
JOIN orders_to_products ON orders.id = orders_to_products.order_id
WHERE users.id = 3;


--- Таска: знайти всі замовлення, в яких були замовлені будь-які моделі Самсунга


SELECT * 
FROM products JOIN orders_to_products 
ON products.id = orders_to_products.product_id
WHERE brand = 'Samsung';


--- id юзерів, які замовляли телефони  Samsung
SELECT customer_id 
FROM products JOIN orders_to_products 
ON products.id = orders_to_products.product_id
JOIN orders ON orders_to_products.order_id = orders.id
WHERE brand = 'Samsung'
GROUP BY customer_id;


-- дізнатись мейли всіх, хто замовляв телефони Samsung

SELECT email 
FROM products JOIN orders_to_products 
ON products.id = orders_to_products.product_id
JOIN orders ON orders_to_products.order_id = orders.id
JOIN users ON orders.customer_id = users.id
WHERE brand = 'Samsung'
GROUP BY email;


SELECT email 
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
JOIN orders AS o
ON otp.order_id = o.id
JOIN users AS u
ON o.customer_id = u.id
WHERE brand = 'Samsung'
GROUP BY email;


/* 
Вивести всі замовлення та кошторис цього замовлення
*/
SELECT otp.order_id, sum(p.price*otp.quantity) 
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
GROUP BY otp.order_id;


--- Перевіряємо:
-- order 273 --- 44350.53
SELECT * 
FROM orders_to_products
WHERE order_id = 273;

SELECT * 
FROM products
WHERE id IN (180, 162, 156, 133);


/*
180 * 3 = 1003.61
162 * 2 = 8742.58
156 * 4 = 4354.96
133 * 1 = 6434.70
*/

-- Задача: отримати мейли користувачів, які НЕ робили замовлень


--- Всі юзери, які РОБИЛИ замовлення та кількість їхніх замовлень

SELECT u.*, count(o.id)
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;

-- Всі юзери, незалежно від того, робили замовлення чи ні

SELECT u.*, count(o.id)
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id
ORDER BY u.id DESC;

--- ТІЛЬКИ юзери без замовлень

SELECT u.*
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.customer_id
WHERE o.id IS NULL;

INSERT INTO products (category, price, quantity, brand, model)
VALUES (
    'TV',
    100,
    1,
    'Noname',
    '111'
  );


-- Знайти продукт, який ніколи не купували

-- Всі продукти, які фігурували в замовленнях
  SELECT p.* 
  FROM orders_to_products AS otp
  JOIN products AS p 
  ON otp.product_id = p.id
  GROUP BY p.id;

-- ВСІ продукти, навіть ті, які не купували

  SELECT p.* 
  FROM orders_to_products AS otp
  RIGHT JOIN products AS p 
  ON otp.product_id = p.id
  GROUP BY p.id;

  SELECT p.* 
  FROM orders_to_products AS otp
  RIGHT JOIN products AS p 
  ON otp.product_id = p.id
  WHERE otp.order_id IS NULL;

  /*

Знайти найпопулярніший продукт
- порахувати, скільки замовлень стосувалося цього товару
- порахувати кількість проданих екземплярів

  */


  SELECT p.*, sum(otp.quantity) 
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY p.id;


  -- Перевіряємо: 
  -- продукт 115 купували 59 штук

  SELECT * FROM orders_to_products AS otp
  WHERE product_id = 115;

    SELECT p.*, sum(otp.quantity) 
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY p.id
  ORDER BY sum(otp.quantity) DESC
  LIMIT 1;


  -- ТОП-3 найпопулярніших
      SELECT p.*, sum(otp.quantity) 
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY p.id
  ORDER BY sum(otp.quantity) DESC
  LIMIT 3;


  