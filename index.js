const {Client} = require('pg');

const config = {
    user: 'postgres',
    password: 'Anastasiia07111607',
    host: 'localhost',
    port: 5432,
    database: 'postgres_first'
}

async function start() {

// робимо підключення до БД
const client = new Client(config);

await client.connect()

const user = {
    id: 1,
    first_name: 'Nick',
    last_name: 'Row',
    birth_date: '1990-01-01',
    email: 'fdsfdfd@sf',
    user_password: 'fsdafsdaf',
    height: 3.10,
    is_subscribe: false
};

// робимо роботу

// Таска: написати insert-запит на вставку юзера в БД

const query = `INSERT INTO users(first_name,last_name, birth_date, email, user_password, height, is_subscribe) VALUES
('${user.first_name}', '${user.last_name}', '${user.birth_date}', '${user.email}', '${user.user_password}', ${user.height}, ${user.is_subscribe});`

const result = await client.query(query);
console.log(result);


// перед тим, як наш код закінчить роботу - маємо закрити коннешн

await client.end()

}

start();
