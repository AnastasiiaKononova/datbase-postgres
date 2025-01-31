const {Client} = require('pg');
const User = require('./user');
const Phone = require('./Phone');
const Order = require('./Order');

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

Order._client = client;

Phone._client = client;
Phone._tableName = 'products';

module.exports = {
    User,
    Phone,
    Order,
    client
}