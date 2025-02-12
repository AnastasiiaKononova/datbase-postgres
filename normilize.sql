/*

Функціональна залежність - якщо два кортежа співпадають по значенню Х, 
то вони співпадають і по Y

Нормалізація - процес усунення надлишковості даних (або заздалегідь проектування БД) 
таким чином, щоб привести БД до мінімальної надлишковості.

1NF
(відповідність реляційній моделі):
(CУБД) - в кожній комірці одиночне (атомарне) значення
(СУБД) - в стовпці можуть бути тільки значення одного домена
(Наша задача) - відсутність однакових кортежів (рядків)
(Наша задача) - відсутні масиви та списки (та складні структури)

2NF
(ключ)
- БД вже має бути в 1NF
- таблиця має ключ
- всі інші (не ключові) стовпці залежать від ключа.
ЯКЩО ключ составний, то всі неключові стовпці залежать від ВСІХ ключових стовпів

*/

DELETE FROM b
WHERE v = 'XXX';

-- Або ввести обмеження унікальності, або імплементувати ДОДАТКОВУ ідентифікацію

ALTER TABLE b
ADD COLUMN id serial PRIMARY KEY;

INSERT INTO b (v) VALUES
('XXX'), ('XXX');

SELECT * FROM b 
ORDER BY id DESC;

INSERT INTO b (v, id) VALUES
('XXX', 8); --- не можу порушити обмеження, бо id унікальний


---2NF (example)

DROP TABLE employees;

CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(300),
    deparment varchar(200),
    position varchar(100),
    car_aviability boolean
);

INSERT INTO employees (name, deparment, position, car_aviability) VALUES
('John', 'HR', 'marketing', false),
('Jane', 'Sales', 'manager', false),
('Jake', 'Development', 'devOps', false),
('Andrew', 'Logistic','driver', true);

CREATE TABLE positions (
    name varchar(200) PRIMARY KEY,
    car_aviability boolean
); -- стовбець, який мав залежність від неключового стовпця переїжджає до іншої таблиці

DROP TABLE employees;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(300),
    position varchar(200) REFERENCES positions(name)
);

INSERT INTO positions VALUES 
('HR', false), ('Sales', false), ('Developer', false), ('Driver', true);

INSERT INTO employees (name, position) VALUES
('John', 'HR'),
('Jane', 'Sales'),
('Jake', 'Developer'),
('Andrew', 'Driver');

--- Чи відповідають таблиці 2NF?
--- Так, обидві таблиці відповідають 1NF, мають ключі та всі неключові стовпці тепер залежать від ключових

SELECT * 
FROM employees 
JOIN positions
ON employees.position = positions.name;

INSERT INTO employees (name, position)
VALUES ('Rick', 'Driver');