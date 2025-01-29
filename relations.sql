DROP TABLE products;

CREATE TABLE products (
    id serial PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    category VARCHAR(300),
    price DECIMAL(16,2) NOT NULL CHECK (price > 0),
    quantity INT CHECK (quantity > 0),
    UNIQUE(name, category)
);

INSERT INTO products (name, category, price, quantity) VALUES
('S10', 'phones', 230.1, 5),
('A5', 'TV', 342.1, 10),
('Key2', 'phones', 23.1, 6);

INSERT INTO users (
    first_name,
    last_name,
    birth_date,
    email,
    user_password,
    height,
    is_subscribe
  )
VALUES (
    'John',
    'Doe',
    '1990-01-01',
    'dsasd@sf',
    'fsdafsdaf',
    3.1,
    FALSE
  ),
  (
    'Jane',
    'Loe',
    '1990-01-01',
    'ddsaq32@sf',
    'fsdafsdaf',
    2.1,
    FALSE
  ),
  (
    'Radf',
    'R',
    '1990-01-01',
    'dsdwqd@sf',
    'fsdafsdaf',
    2.1,
    FALSE
  );

/*
Зв'язки (связи, relations)

1. За кількістю учасників: бінарні, тернарні, н-арні 

2. За типом підключення (зв'язку)

    1:1 - один до одного
        Пр: 1 тренер - 1 команда, 1 капітан - 1 корабель

    1:m - один до багатьох
        Пр: 1 юзер - багато замовлень, 1 teamLead - багато проєктів, 1 товар - багато постачальників
        Реалізація: обмеження зовнішнього ключа

    m:n - багато до багатьох
        Пр: студенти - дисципліни (1 студент слухає багато дисциплін, на одній дисципліні може бути багато студентів)
        Реалізація: зв'язуюча таблиця

3. За жорсткістю зв'язку:
0..1 - 
у тренера може бути команда, а може не бути,  - 0
у юзера можуть бути замовлення, а може не бути - 0
У замовлення ЗАВЖДИ має бути покупець - 1
  */


CREATE TABLE orders (
    id serial PRIMARY KEY,
    created_at timestamp DEFAULT current_timestamp,
    customer_id INT REFERENCES users(id) -- вказую новий стовбець таблиці orders, значення в якому ГАРАНТОВАНО пов'язані зі значеннями таблиці users (стовбець id)
);

/* Зв'язок між юзером і його замовленням - 1:m (1 юзер - багато замовлень) */

/* Зв'язок між товарами і замовленнями - m:n (1 товар - багато замовлень, багато товарів в 1 замовленні) 

Реалізується за допомогою додаткової (зв'язуючої) таблиці, яка містить складаний первинний ключ - пов'язує дані з першої таблиці і другої одночасно. 
Така таблиця може містити додаткові дані
Така таблиця називається ім'яТаблиці_to_ім'я2таблиці
orders_to_products, students_to_subjects
*/

CREATE TABLE orders_to_products (
    order_id INT REFERENCES orders(id),
    product_id INT REFERENCES products(id),
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);

 INSERT INTO orders(customer_id) VALUES
 (1);

 INSERT INTO orders_to_products (order_id, product_id, quantity) VALUES
 (1, 3, 2 ), (1, 2, 10);

/*

Таска: створити таблицю 
    Книга
        - id
        - автор
        - назва
        - рік випуску
        - кількість сторінок
        - user_id

    Читачі
        - id
        - first_name
        - last_name
        - email

    Читач може брати книгу в бібліотеці для читання
    1 книга читається 1 людиною. 1 людина може читати декілька книг - зв'язок 1:m
*/

CREATE TABLE readers(
    id serial PRIMARY KEY,
    first_name VARCHAR(300),
    last_name VARCHAR(300),
    email VARCHAR(300)
);

CREATE TABLE books (
    id serial PRIMARY KEY,
    author VARCHAR(300),
    name VARCHAR(300),
    year DATE,
    pages INT,
    reader_id INT REFERENCES readers(id)
);

DROP TABLE books; -- першою маємо видаляти підлеглу (залежну) таблицю, ЯКА посилається

DROP TABLE readers; -- і тільки після цього можемо видалити іншу, на яку йшло посилання

/*
Створити чат між юзерами

Чат
    - id
    - назва
    - власник чату (id певного юзера)
    - дата створення чату

До чатів можуть додаватися юзери
В 1 чаті може бути багато юзерів
1 юзер може вступити до багатьох чатів - m:n

chats_to_users
    - посилання на юзера
    - посилання на чат
(юзер в тому самому чаті не може сидіти двічі)
*/

CREATE TABLE chats (
    id serial PRIMARY KEY,
    name VARCHAR(300),
    owner_id INT REFERENCES users(id),
    created_at timestamp NOT NULL DEFAULT current_timestamp
);

INSERT INTO chats (name, owner_id) VALUES
('First chat', 1);

CREATE TABLE chats_to_users (
    user_id int REFERENCES users,
    chat_id int REFERENCES chats,
    PRIMARY KEY (user_id, chat_id)
);

INSERT INTO chats_to_users (user_id, chat_id) VALUES 
(2, 1), (3,1);

/*

Зв'язок 1:1

Капітан - команда
1 капітан має 1 команду
1 команда має 1 капітана

Оскільки неможливо створити таблицю, яка посилатиметься в нікуди, маємо одну з двох таблиць створити без посилання, потім створити другу, яка посилається на першу і змінити (alter) першу, додавши їй посилання
Insert в такий зв'язок частіше за все виконується в межах однієї транзакції
*/

CREATE TABLE captains (
    id serial PRIMARY KEY,
    first_name VARCHAR(300)
   
);

CREATE TABLE commands (
    id serial PRIMARY KEY,
    name VARCHAR(300),
    captain_id INT REFERENCES captains(id)
);

ALTER TABLE captains
ADD COLUMN command_id int REFERENCES commands(id);

ALTER TABLE captains 
DROP COLUMN command_id;

DROP TABLE commands;

DROP TABLE captains;

DROP TABLE dogs;

/*

Сутність контент (content)
    - назва
    - опис
    - дата створення
    - автор (юзер)
Реакції
    - isLiked (true - контент лайкнули, якщо false - дизлайкнули, якщо null - оцінки немає)
Реакція - це відношення юзера до контент
(зв'язок m:n)

*/