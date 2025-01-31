const { getUsers } = require("./api/getUsers");
const { User, client, Phone, Order } = require("./models");
const { generatePhones } = require("./utils/generateProducts");

// робимо підключення до БД
async function start() {
  await client.connect();

  // // робимо роботу
  // const userArray = await getUsers();

  // // просимо модель зганяти запитом до БД

  // // const result  = await User.bulkCreate(userArray);
  // const phones = generatePhones(100);
  // const result = await Phone.bulkCreate(phones);

  /// спочатку - робимо запит до БД на вже існуючих юзерів та телефони
  const { rows: users } = await User.findAll();
  const { rows: phones } = await Phone.findAll();

  const result = await Order.bulkCreate(users, phones);
  console.log(result);

  // перед тим, як наш код закінчить роботу - маємо закрити коннешн

  await client.end();
}

start();
