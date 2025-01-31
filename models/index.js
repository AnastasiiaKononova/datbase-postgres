const {Client} = require('pg');
const User = require('./user');

const config = {
    user: 'postgres',
    password: 'Anastasiia07111607',
    host: 'localhost',
    port: 5432,
    database: 'postgres_first'
}

const client = new Client(config);

User._client = client;
User._tableName = 'users';

module.exports = {
    User,
    client
}