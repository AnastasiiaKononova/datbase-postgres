ALTER TABLE orders
ADD COLUMN status bool DEFAULT false;

UPDATE orders
SET status = TRUE
WHERE id %2 = 1;

SELECT *
FROM orders
ORDER BY id;

SELECT id, customer_id, created_at, status AS order_status 
FROM orders;

/*
CASE

Синтаксис 1 (схожий на if-else-if)
 
 CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result3
END

Синтаксис 2 (Схожий на switch-case)

CASE (обчислюємо значення)
    WHEN (варіант заначення 1) THEN result1
    WHEN (варіант заначення 2) THEN result2
    ELSE result3
END

*/

SELECT *, (CASE
            WHEN status = true THEN 'done'
            WHEN status = false THEN 'processing'
            ELSE 'other status'
            END) AS order_status
FROM orders;

SELECT *, (CASE 
            WHEN status THEN 'done'
            ELSE 'processing'
            END
             ) AS order_status
FROM orders;

--- Вивести юзерів і на основі місяця їхнього народження, вивести в яку пру року він народився

SELECT birth_date, (
    CASE extract(month from birth_date)
        WHEN 1 THEN 'winter'
        WHEN 2 THEN 'winter'
        WHEN 3 THEN 'spring'      
        WHEN 4 THEN 'spring'
        WHEN 5 THEN 'spring'
        WHEN 6 THEN 'summer'
        WHEN 7 THEN 'summer'
        WHEN 8 THEN 'summer'
        WHEN 9 THEN 'autumn'
        WHEN 10 THEN 'autumn'
        WHEN 11 THEN 'autumn'
        WHEN 12 THEN 'winter'      
        ELSE 'other season'     
    END
) AS birth_season
FROM users;

--- Вивести юзерів, і стовбець access_status, якщо юзеру > 18 - true, якщо менше - то false

SELECT *, (
    CASE 
        WHEN (extract(years from age(birth_date))) > 18 THEN TRUE 
        WHEN (extract(years from age(birth_date))) < 18 THEN FALSE
    END         
    ) AS access_status
FROM users;

--- Вивести всі телефони, з новим стовпцем "виробник" (manufacturer)
-- Для iPHONE - Apple, для інших - 'other'

SELECT *, (
    CASE 
    WHEN brand ILIKE 'iphone' THEN 'Apple'
    ELSE 'other'
    END
) AS manufacturer
FROM products;

--- Вивести телефони з їхньою фін.категорією
-- 100-1000 - budget, 1000-7000 - middle, 7-10k - flagman

SELECT *, (
    CASE 
        WHEN price BETWEEN 100 AND 1000 THEN 'budget'
        WHEN price BETWEEN 1000 AND 7000 THEN 'middle'
        WHEN price BETWEEN 7000 AND 10000 THEN 'flagman'
    END
) AS "price class" 
FROM products;