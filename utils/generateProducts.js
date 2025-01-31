const _ = require('lodash');

const PHONES_BRAND = [
    'Samsung',
    'iPhone',
    'Siemens',
    'Motorola',
    'Nokia',
    'Sony',
    'Alcatel',
    'Realme',
    'Xiaomi'
];

const generateOnePhone = key => ({
    brand: PHONES_BRAND[_.random(0, PHONES_BRAND.length - 1, false)],
    model: `model ${key}`,
    quantity: _.random(5, 1500, false),
    price: _.random(100, 10000, false),
    category: 'phones'
});

module.exports.generatePhones = (length = 50) => new Array(length).fill(null).map((el, i) =>
generateOnePhone(i));