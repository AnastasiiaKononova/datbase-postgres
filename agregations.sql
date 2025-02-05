SELECT * FROM users;

SELECT *, concat(first_name, ' ', last_name) AS "full_name"
FROM users;

/* SELECT повертає таблицю (табличний вираз) 
Табличний вираз - представлення даних в вигляді таблиці, 
навіть якщо фізично такої таблиці немає

*/

SELECT max(height) FROM users;

/*
Агрегаційна функція - функція, яка приймає множину значень і вираховує певне єдине значення (результат) для групи вхідних даних

- max - максимальне значення

- min - мінімальне значення з вхідних даних

- avg - середнє арифметичне

- count - кількість (кількість рядків, які отримала)

- sum - сума по всіх вхідних значеннях

*/

SELECT count(id) FROM users;

-- Таска - знайти середній зріст користувачів

SELECT avg(height) FROM users;

/* Агрегаційна функція може отримати результат по кожній групі значень. 
Для цього потрібно розбити всі значення по групам (згрупувати за певним 
критерієм) */

SELECT avg(height), gender
FROM users
GROUP BY gender;

-- Таска: максимальний зріст чоловіків та жінок

SELECT max(height), gender
FROM users
GROUP BY gender;

-- Задача: порахувати кількість чоловіків та жінок, які народились після 2000

SELECT count(id), gender
FROM users
WHERE extract(years from birth_date) > 2000
GROUP BY gender;

/*

Таски:

1. Середня вага всіх користувачів
2. Середня вага всіх жінок і чоловіків окремо
3. Мінімальна та максимальна вага по кожному гендеру
4. Кількість юзерів, які народились пізніше 1987р
5. Кількість юзерів з певним ім'ям 
6. Кількість юзерів віком від 20 до 30

*/

---1

SELECT avg(weight) FROM users;

---2

SELECT avg(weight), gender
FROM users
GROUP BY gender;

---3

SELECT min(weight), max(weight), gender
FROM users
GROUP BY gender;

---4

SELECT count(*)
FROM users
WHERE extract(years from birth_date) > 1987;

---5

SELECT count(*)
FROM users
WHERE first_name = 'Aleks';

---6

SELECT count(*)
FROM users
WHERE extract(years from age(birth_date)) BETWEEN 20 AND 30;


