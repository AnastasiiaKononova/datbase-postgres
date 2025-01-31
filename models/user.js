const {mapUsers} = require('../utils/mapUser');

class User {
    static _client;
    static _tableName;
    static async findAll() {
        return this._client.query(`SELECT * FROM ${this._tableName}`);
    }
    static async bulkCreate(users) {
        const mapped = mapUsers(users);
        console.log(mapped);
        return this._client.query(`INSERT INTO ${this._tableName} (first_name, last_name, email, birth_date, height, is_subscribe, gender) VALUES ${mapped};`);
    }
}

module.exports = User;