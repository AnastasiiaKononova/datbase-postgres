const {Client} = require('pg');
const User = require('./user');
const Phone = require('./Phone');

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

Phone._client = client;
Phone._tableName = 'products';

module.exports = {
    User,
    Phone,
    client
}