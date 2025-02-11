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