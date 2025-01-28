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


/* constraints */

DROP TABLE users;

CREATE TABLE users(
    first_name VARCHAR(256) NOT NULL CHECK (first_name != ''),
    last_name VARCHAR(256) NOT NULL CHECK (last_name != ''),
    birth_date date CHECK (birth_date > '1900-01-01' AND birth_date < current_date),
    email VARCHAR(300) NOT NULL UNIQUE CHECK(email != ''),
    user_password VARCHAR(300) NOT NULL CHECK(user_password != ''),
    height numeric(3,2) CONSTRAINT normal_height CHECK (height BETWEEN 0 AND 5.0),
    is_subscribe bool NOT NULL,
    created_at TIMESTAMP DEFAULT current_timestamp
);

/* обмеження вказуються при визначенні стовпця або всієї таблиці */

INSERT INTO users (first_name, last_name, birth_date, email, user_password, height, is_subscribe) VALUES 
('', '','2025-09-23', 'fare@j.shhf', 'kjhf@#$ujhsdf', 8.0, FALSE);

/* Constraint "users_height_check"
У будь-якого обмеження (констрейнту) є ім'я, за яким ми можемо до нього доступитися
По дефолту, якщо не вказано іншого, ім'я формується за принципом:
ім'яТаблиці_ім'яСтовпця_типПеревірки
 */


 INSERT INTO users (first_name, last_name, email, birth_date, user_password, height, is_subscribe) VALUES 
 ('Kick', 'Loe', 'ffgh333@j.hgf', '1996-02-03', 'kkklf@#$ujhsdf', 3.0, FALSE),
('Rick', 'Doe', 'fare333@j.sdf', '1993-02-03', 'kjhf@#$ujhsdf', 3.0, FALSE); -- "users_email_key"


 INSERT INTO users (first_name, last_name, email, birth_date, user_password, height, is_subscribe) VALUES 
 ('Kick', 'Loe', 'ffgh333@j.hgf', '1996-02-03', 'kkklf@#$ujhsdf', 3.0, FALSE);


 INSERT INTO users (first_name, last_name, email, birth_date, user_password, height, is_subscribe) VALUES 
('Rick', 'Doe', 'fare333@j.sdf', '1993-02-03', 'kjhf@#$ujhsdf', 3.0, FALSE);

/*
Створити таблицю для повідомлень (messages)
    body рядок тексту, не пустий, максимум 5000
    автор рядок тексту, не пустий, 256
    дата створення - таймштемп, по дефолту поточний
    чи прочитано - бул, по дефолту не прочитане
*/
DROP TABLE messages;

CREATE TABLE messages(
    id serial NOT NULL UNIQUE,
    body VARCHAR(5000) NOT NULL CHECK (body != ''),
    author VARCHAR(256) NOT NULL CHECK (author != ''),
    created_at TIMESTAMP DEFAULT current_timestamp,
    is_read BOOL DEFAULT FALSE
);

INSERT INTO messages (body, author) VALUES
('Hello', 'John'), ('Hi', 'Jane');

INSERT INTO messages (body) VALUES 
('Hello');
INSERT INTO messages (body, author, id) VALUES 
('Hello', 'John', 7);

/*
Переробити таблицю машин
 Таска:
описати таблицю машин
Машина
    - бренд - рядок - обов'язковий, не пустий
    - модель - рядок - не пуста
    - рік випуску - дата з 01-01
    - літраж (об'єм бака) - 40 - ціле число від 0 до 1500
    - колір - рядок
    - об'єм двигуна (1600) - ціле число
    - тип кузова (седан, універсал) - рядок
    - тип пального - рядок
    - ідентифікатор
*/

DROP TABLE cars;

CREATE TABLE cars (
    id serial NOT NULL UNIQUE,
    brand VARCHAR(300) NOT NULL CHECK(brand != ''),
    model VARCHAR(300) NOT NULL CHECK(model != ''),
    year DATE,
    volume INT CHECK(volume BETWEEN 0 AND 1500),
    color VARCHAR(100),
    engine_volume INT,
    body_type VARCHAR(100),
    fuel_type VARCHAR(100)
);