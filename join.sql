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

