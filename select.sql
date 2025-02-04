/* SELECT - запит на вибірку даних - DQL - Data Query Language */

-- SELECT (що саме вибрати) FROM (табличний вираз)

SELECT * FROM users;

SELECT first_name, last_name FROM users;

SELECT email FROM users; -- результат повернення команди - таблиця

SELECT first_name, last_name FROM users;

-- обмеження результатів (вибірка даних)

/* SELECT * FROM users
WHERE (умова, яка повертає true для рядків, які підходять) */

SELECT * FROM users
WHERE gender = 'female';

SELECT * FROM users
WHERE gender = 'female' AND is_subscribe = 'TRUE';

/*

Таска: отримати всіх юзерів, в який id парний

*/

SELECT * FROM users
WHERE id % 2 = 0;

-- Таска 2: отримати всіх юзерів, які підписані на новини і при цьому їхній зріст > 1.5

SELECT * FROM users
WHERE is_subscribe = 'TRUE' AND height > 1.5;

