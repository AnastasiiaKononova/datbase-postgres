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

-----
SELECT * FROM users
WHERE first_name IN ('John', 'Jane', 'William');

SELECT * FROM users
WHERE id IN (101, 120, 150);

SELECT * FROM users
WHERE id BETWEEN 100 AND 110;

-- Таска: вибрати юзерів зростом від 1.5 до 1.9

SELECT * FROM users
WHERE height BETWEEN 1.5 AND 1.9;

SELECT * FROM users
WHERE height >= 1.5 AND height <= 1.9;

-----

SELECT * FROM users 
WHERE first_name LIKE 'K%';

/*

% - будь-яка кількість будь-яких символів

_ - 1 будь-який символ

*/

SELECT * FROM users
WHERE first_name LIKE '___';

-- Таска: знайти юзерів, імена яких закінчуються на літеру "а"

-- ILIKE - реєстро-незалежна форма

SELECT * FROM users
WHERE first_name LIKE '%a';

ALTER TABLE users
ADD COLUMN weight INT CHECK (weight > 0);

--- Оновлення даних

UPDATE users
SET weight = 60
WHERE height > 1.5;

-- Таска:оновити вагу користувачів, в яких довжина імені - 5 літер - встановити 90кг

UPDATE users
SET weight = 90
WHERE first_name LIKE '_____';

UPDATE users
SET weight = 80
WHERE id % 2 = 1
RETURNING *;

DELETE FROM users
WHERE id = 52
RETURNING *;

--- Співробітники: збільшити зп на 20%

UPDATE employees
SET salary = salary * 1.2
WHERE working_hours > 150;
-----

SELECT * FROM users
WHERE birth_date > '1990-01-01';

SELECT * FROM users
WHERE extract(month from birth_date) = 9;

SELECT * FROM users
WHERE extract(days from birth_date) = 1;

-- всі юзери, яким більше ніж 20 років:

SELECT * FROM users
WHERE extract(years from age(birth_date)) > 20;

/*
Таски:

1. Отримати всіх повнолітніх користувачів чоловічого роду

2. Отримати всіх користувачів жіночого роду, ім'я яких починається на "А"

3. Отримати користувачів віком від 20 до 40 років (включно)

4. Отримати всіх, хто народився в січні

5. Всім користувачам, які народились 1 листопада змінити підписку на TRUE

6. Всім користучам чоловічого роду зростом від 1.7 до 1.9 змінити вагу на 95кг.
*/

---1

SELECT * FROM users
WHERE extract(years from age(birth_date)) > 18 AND gender = 'male';

--2

SELECT * FROM users
WHERE gender = 'female' AND first_name LIKE 'A%';

--3

SELECT * FROM users
WHERE extract(years from age(birth_date)) BETWEEN 20 AND 40;

--4

SELECT * FROM users
WHERE extract(month from birth_date) = 1;

--5

UPDATE users
SET is_subscribe = TRUE
WHERE extract(month from birth_date) = 11 AND extract(days from birth_date) = 1;

--6

UPDATE users
SET weight = 95
WHERE gender = 'male' AND height BETWEEN 1.7 AND 1.9;


------ Alias - псевдонім

SELECT id AS "Порядковий номер", 
first_name AS name, 
last_name AS "Прізвище", 
gender AS "Стать", 
email 
FROM users;

SELECT id, first_name AS "Name", last_name AS "Last name"
FROM users AS u;

SELECT id "Порядковий номер", first_name "Ім'я", last_name "Прізвище"
FROM users; -- не раджу

SELECT id, first_name, last_name
FROM users AS u 
WHERE u.id = 100; -- доступ до атрибута певної таблиці

SELECT id, first_name, last_name 
FROM users AS u   --- якщо я вже дала псевдонім таблиці, то я МАЮ звертатись далі за цим псевдонімом
WHERE users.id = 100; -- вот тут маю звернутись до таблиці u


----Pagination--------

/*

Пагінація - витягання не всього масиву інфи, а тільки частини

Складається з 2 етапів:
1. Обмеження кількості резутльтатів
2. Перегляд наступної "кількості" зі всього

*/

--1

SELECT * FROM users
LIMIT 15; -- скільки результатів за один запит ми отримуємо (максимум)

SELECT * FROM chats
LIMIT 10;

-- 2 - відступ - OFFSET

SELECT * FROM users
LIMIT 15
OFFSET 30;

--- OFFSET (якщо використовуємо pages, наприклад на 1 сторінку - 10 результатів)
-- 1 page - LIMIT 10 OFFSET 0
-- 2 page LIMIT 10 OFFSET 10
-- 3 page LIMIT 10 OFFSET 20
-- OFFSET = (page - 1) * LIMIT



--- localhost:5000/users?page=1&limit=50

-------

SELECT concat(first_name, ' ', last_name) AS "full name"
FROM users;

SELECT concat(first_name, ' ', last_name) AS "full name"
FROM users
WHERE char_length(concat(first_name, ' ', last_name)) > 10;

-- варіант з під-запитом

SELECT * FROM (
    SELECT id, concat(first_name, ' ', last_name) AS "full name" FROM users 
) AS "FN"
WHERE char_length("FN"."full name") > 10;

--- Витягти всіх користувачів, в яких email < 7 символів

SELECT * FROM users
WHERE char_length(email) < 10;

------

/*

-- INSERT

1. Створити таблицю "workers"
- id
- birthday
- name
- salary

2. Додати робітника Ярославу з зп 1200

3. Додати робітника Олега з зп 400

4. Додати одним запитом двох робітників - Олександра, зп 900, р.н. 85 і Марію 95р.н. зп 200

--- UPDATE
1. Встановити Олегу зп 500
2. Встановити робітнику з id = 4 рік народження 87
3. Всім, в кого зп < 500 - збільшити до 700
4. Робітникам з id від 2 до 5 встановити рік народження 99
5. Перейменувати Сашу в Женю

-- SELECT
1. Отримати інф. про робітника з id = 3
2. Отримати всіх, в кого зп > 400
3. Дізнатись зп і вік Жені
4. Отримати всіх на ім.я Петя
5. Отримати всіх у віці 27 років або зп > 1000
6. Отримати всіх віком від 25 до 28
7. Отримати користувачів, в яких непарний id і зп > 500

*/

---1

CREATE TABLE workers (
    id serial PRIMARY KEY,
    birthday date CHECK (birthday > '1900-01-01'),
    name varchar(300) NOT NULL CHECK (name != ''),
    salary int NOT NULL CHECK (salary > 0)
);

---2

INSERT INTO workers (name, birthday, salary) VALUES
('Yaroslava', '1987-02-06', 1200);

---3

INSERT INTO workers (name, birthday, salary) VALUES
('Oleg', '1995-01-08', 400);

---4

INSERT INTO workers (name, birthday, salary) VALUES
('Oleksandr', '1985-01-08', 900), ('Maria', '1995-03-08', 200);

---UPDATE
---1

UPDATE workers
SET salary = 500
WHERE name = 'Oleg';

---2

UPDATE workers
SET birthday = '1987-03-05'
WHERE id = 4;

---3

UPDATE workers
SET salary = 700
WHERE salary < 500;

---4

UPDATE workers
SET birthday = '1999-03-05'
WHERE id BETWEEN 2 AND 5;

---5

UPDATE workers
SET name = 'Evgeniy'
WHERE name = 'Oleksandr';

---SELECT
---1

SELECT * FROM workers
WHERE id = 3;

---2

SELECT * FROM workers
WHERE salary > 400;

---3

SELECT salary, birthday FROM workers
WHERE name = 'Evgeniy';

---4

SELECT * FROM workers
WHERE name LIKE 'Pet%';

---5

SELECT * FROM workers
WHERE (extract(YEAR FROM age(birthday)) = 27 OR salary > 1000);

---6

SELECT * FROM workers
WHERE extract(years from age(birthday)) BETWEEN 25 AND 28;

---7

SELECT * FROM workers
WHERE id % 2 !=0 AND salary > 500;