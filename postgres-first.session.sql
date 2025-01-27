CREATE TABLE my_first_table(
    first_column INT,
    second_column VARCHAR(64),
    third_column  TIMESTAMP
);

DROP TABLE my_first_table;

/*
Юзери
    - ім'я - максимум 256 символів
    - прізвище - максимум 256
    - дата народження - точність 1 день
    - емейл - максимум 300 символів
    - пароль - максимум 300 символів
    - підписку - або так, або ні
*/

DROP TABLE users;

CREATE TABLE users(
    first_name VARCHAR(256),
    last_name VARCHAR(256),
    birth_date date,
    email VARCHAR(300),
    user_password VARCHAR(300),
    height numeric(3,2),
    is_subscribe bool
);

INSERT INTO users VALUES
('John', 'Doe', '1990-09-01', 'sgdyg@j.sfg', 'fdfvddvf@#$ffh');

INSERT INTO users VALUES
('Kate', 'Kick', '1970-05-12', 'hfgdhgeh@jjh', 'efgdvfegf', 5.3, TRUE),
('Dick', 'Low', '2005-02-01', 'gcs@gvfgv', 'fdhgbvb', 3.1, FALSE);

INSERT INTO users VALUES
('', 'kjhfds', '2800-01-02', 'kh2342', 'kjshfdkjfh', 8.1, FALSE);

/* Вказання порядку вставки */

INSERT INTO users (last_name, first_name, email, birth_date, is_subscribe) VALUES
('Snow', 'Kick', 'kjhfds', '1990-01-01', TRUE),
('Rnow', 'Lick', 'khfds', '2000-01-01', FALSE),
('Dnow', 'Snick', 'kjsher', '1220-10-10', FALSE);

------------------------
DROP TABLE second_table; 
CREATE TABLE second_table(
    col numeric(3,2)
);

INSERT INTO second_table VALUES
(5);
/* Якщо ціле число записувати до стовпця з дісними числами - доповниться нулями після крапки, якщо навпаки - вріжеться до цілої частини */


/* Таска:
описати таблицю машин
Машина
    - бренд
    - модель
    - рік випуску
    - літраж (об'єм бака) - 40
    - колір
    - об'єм двигуна (1600)
    - тип кузова (седан, універсал)
    - тип пального
*/

CREATE TABLE cars (
    brand VARCHAR(300),
    model VARCHAR(300),
    year DATE,
    volume INT,
    color VARCHAR(100),
    engine_volume INT,
    body_type VARCHAR(100),
    fuel_type VARCHAR(100)
);
