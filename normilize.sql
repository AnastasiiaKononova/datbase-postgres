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

3NF
(неключові)
- БД вже в 2NF
- немає транзитивних залежностей (неключові стовпці не 
намагаються бути ключовими)

BCNF (посилена 3NF)
(составний ключ ПРАВИЛЬНИЙ)
- БД вже в 3NF
- жоден з стовпців составного ключа не залежить від 
неключового стовпця

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

---- 3NF

DROP TABLE employees;
DROP TABLE positions;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(300),
    deparment varchar(300),
    department_phone varchar(10)
);

INSERT INTO employees (name, deparment, department_phone) VALUES
('John', 'HR', '222-111-22'),
('Jane', 'Sales', '333-222-11');

--- Номер департамента залежить від департамента, а не від робітника
-- Рішення: декомпозиція таблиці


CREATE TABLE deparments(
    name varchar(300) PRIMARY KEY,
    phone varchar(10)
);

CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(300),
    deparment varchar(300) REFERENCES deparments(name)
); -- 3NF

--- Нормальна форма Бойса-Кодда (BCNF)

/*
Є викладачі, студенти, предмети
(teachers, students, subjects)
1 викладач - 1 предмет
у студента може бути багато дисциплін
1 предмет слухає багато студентів

teachers n:1 subjects
students m:n subjects
students m:n teachers

*/

CREATE TABLE students(
    id serial PRIMARY KEY
);

INSERT INTO students VALUES (1), (2);

CREATE TABLE teachers(
    id serial PRIMARY KEY
);
DROP TABLE teachers;

INSERT INTO teachers VALUES (1), (2);

CREATE TABLE students_to_teachers(
    student_id integer REFERENCES students(id),
    teacher_id integer REFERENCES teachers(id),
    subject varchar(32),
    PRIMARY KEY (student_id, teacher_id)
);-- Частина составного первинного ключа ЗАЛЕЖИТЬ від неключового стовпця (teacher -> subject)

INSERT INTO students_to_teachers (student_id, teacher_id, subject) VALUES
(1, 1, 'biology'),
(1, 2, 'math'),
(2, 1, 'math'),
(2, 2, 'phisics');

-- Рішення:

CREATE TABLE subjects (
    name varchar(200) PRIMARY KEY
);

-- зміна teachers

CREATE TABLE teachers (
    id serial PRIMARY KEY,
    subject varchar(200) REFERENCES subjects(name)
);

-- students -> teachers (які вже прив'язані до свого предмета)

CREATE TABLE students_to_teachers (
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    PRIMARY KEY (teacher_id, student_id)
);

/*

Проектування БД має спиратись на принцип 
Single source of truth (єдине джерело істини)

Всі факти - первинні (тобто такі, які неможливо 
вивести з інших фактів)

*/

/*

Ресторани роблять піци
Піци від ресторанів розвозять служби доставки

*/

CREATE TABLE restaurants (
    id serial PRIMARY KEY
);

CREATE TABLE delivery_services (
    id serial PRIMARY KEY
);

CREATE TABLE restaurants_to_deliveries (
    restaurant_id int REFERENCES restaurants,
    delivery_id int REFERENCES delivery_services,
    pizza_type varchar(64) NOT NULL,
    PRIMARY KEY (restaurant_id, delivery_id)
);

INSERT INTO restaurants_to_deliveries VALUES
(1, 1, 'peperoni'),
(1, 1, 'sea'),
(1, 1, '4 chease'),
(1, 1, 'hawaii'),
(1, 2, 'peperoni'),
(1, 2, 'sea'),
(1, 2, '4 chease'),
(2, 1, 'pepponi'),
(2, 1, 'special');

-- Рішення?

CREATE TABLE pizza_to_restaurants (
    pizza_type varchar(200),
    restaurant_id int REFERENCES restaurants(id)
);

-- Тепер з таблиці restaurants_to_deliveries можна прибрати піци, і лишити тільки відповідність між ресторанами та службами доставки