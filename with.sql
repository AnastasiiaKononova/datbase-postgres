/*

WITH - можливість створити тимчасову таблицю, яка існуватиме тільки в рамках поточного запиту, 
давати їй аліас і використовувати за цим ім'ям в рамках поточного запиту

WITH псевдонім AS (підзапит, який повертає табличний вираз)
(звичайний запит, який буде використовувати ось цю підзапитну таблицю як звичайну)

*/


---- Задача: вивести id юзерів та їхнє повне ім'я(тих, в кого довжина імені більше 10 символів)

SELECT id, concat(first_name, ' ', last_name) AS full_name
FROM users
WHERE char_length(concat(first_name, ' ', last_name)) > 10;

WITH users_with_fullnames AS (
    SELECT id, concat(first_name, ' ', last_name) AS full_name
    FROM users)
SELECT u.id, u.full_name
    FROM users_with_fullnames AS u
    WHERE char_length(u.full_name) > 10;


/* 

  SELECT u.*, count(*) AS orders_count
  FROM users AS u 
  LEFT JOIN orders AS o
  ON o.customer_id = u.id
  GROUP BY u.id
  HAVING count(*) > (SELECT avg(uwoc.orders_count) 
  FROM (SELECT u.*, count(*) AS orders_count
FROM users AS u 
LEFT JOIN orders AS o
ON o.customer_id = u.id
GROUP BY u.id) AS uwoc);

--- Задача: вивести email користувачів, які зробили замовлень вище середнього

*/

WITH users_with_orders_count AS (
    SELECT u.*, count(*) AS orders_count
    FROM users AS u 
    LEFT JOIN orders AS o
    ON o.customer_id = u.id
    GROUP BY u.id
)
SELECT uwoc.*
FROM users_with_orders_count AS uwoc
WHERE uwoc.orders_count > ( SELECT avg(oc.orders_count) 
        FROM (
            SELECT u.*, count(*) AS orders_count
        FROM users AS u 
        LEFT JOIN orders AS o
        ON o.customer_id = u.id
        GROUP BY u.id) AS oc);

/* Таска: 
витягти всі замовлення та кількість товарів в кожному замовленні
*/

SELECT order_id, sum(quantity)
FROM orders_to_products AS otp
GROUP BY order_id;

/* Всі позиції певного замовлення (інформацію про продукт) */

---Order #85

SELECT p.*
FROM orders_to_products AS otp
JOIN products AS p 
ON otp.product_id = p.id
WHERE otp.order_id = 85;

/* Витягти всіх юзерів, які купували телефони Xiaomi */

SELECT DISTINCT u.*
FROM users AS u
JOIN orders AS o
ON u.id = customer_id
JOIN orders_to_products AS otp
ON o.id = otp.order_id
JOIN products AS p
ON otp.product_id = p.id
WHERE p.brand ILIKE 'Xiaomi';


---- Group by групує варіанти

-- DISTINCT - просто прибирає повторювані значення з результатів

/* 

Середній чек в магазині

SELECT avg(ows.sum)
FROM (
  SELECT otp.order_id, sum(otp.quantity*p.price) AS sum
FROM orders_to_products AS otp
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY otp.order_id
) AS ows;

Таска № 1. Витягти всіх юзерів і ВСІ кошти за замовлення

Таска № 2. Юзери, які залишили більш ніж в середньому грошів в магазині
 */

 SELECT u.*, sum(p.price * otp.quantity)
 FROM users AS u
 JOIN orders AS o
 ON u.id = o.customer_id
 JOIN orders_to_products AS otp
 ON o.id = otp.order_id
 JOIN products AS p
 ON otp.product_id = p.id
 GROUP BY u.id;

 -- юзер 34 купив на 61890

 SELECT *
 FROM orders AS o
 JOIN orders_to_products AS otp
 ON o.id = otp.order_id
 JOIN products AS p
 ON otp.product_id = p.id
 WHERE o.customer_id = 34;

 -- Таска 2:

WITH users_with_costs AS (
    SELECT u.*, sum(p.price*otp.quantity) AS costs
    FROM users AS u
    JOIN orders AS o 
    ON u.id = o.customer_id
    JOIN orders_to_products AS otp 
    ON o.id = otp.order_id
    JOIN products AS p 
    ON otp.product_id = p.id
    GROUP BY u.id)
SELECT * 
FROM users_with_costs AS owc
WHERE owc.costs > ( 
    SELECT avg(costs)
    FROM users_with_costs);

    ---- Середній чек

WITH users_costs AS (
SELECT u.*, sum(p.price*otp.quantity) AS costs
FROM users AS u
JOIN orders AS o 
ON u.id = o.customer_id
JOIN orders_to_products AS otp 
ON o.id = otp.order_id
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY u.id
) 
SELECT avg(costs)
FROM users_costs; ---92749.4


WITH users_costs AS (
SELECT u.*, sum(p.price*otp.quantity) AS costs
FROM users AS u
JOIN orders AS o 
ON u.id = o.customer_id
JOIN orders_to_products AS otp 
ON o.id = otp.order_id
JOIN products AS p 
ON otp.product_id = p.id
GROUP BY u.id
) 
SELECT *
FROM users_costs
WHERE costs > 92749.4;

 