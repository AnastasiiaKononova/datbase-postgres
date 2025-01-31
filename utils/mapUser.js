  // const user = {
    //     id: 1,
    //     first_name: 'Nick',
    //     last_name: 'Row',
    //     birthdate: '1990-01-01',
    //     email: 'fdsfdfd@sf',
    //     password: 'fsdafsdaf',
    //     height: 3.10,
    //     is_subscribe: false
    //   };


    /*
{
  "results": [
    {
      "gender": "female",
      "name": {
        "title": "Miss",
        "first": "Jennie",
        "last": "Nichols"
      },
      "location": {
        "street": {
          "number": 8929,
          "name": "Valwood Pkwy",
        },
        "city": "Billings",
        "state": "Michigan",
        "country": "United States",
        "postcode": "63104",
        "coordinates": {
          "latitude": "-69.8246",
          "longitude": "134.8719"
        },
        "timezone": {
          "offset": "+9:30",
          "description": "Adelaide, Darwin"
        }
      },
      "email": "jennie.nichols@example.com",
      "login": {
        "uuid": "7a0eed16-9430-4d68-901f-c0d4c1c3bf00",
        "username": "yellowpeacock117",
        "password": "addison",
        "salt": "sld1yGtd",
        "md5": "ab54ac4c0be9480ae8fa5e9e2a5196a3",
        "sha1": "edcf2ce613cbdea349133c52dc2f3b83168dc51b",
        "sha256": "48df5229235ada28389b91e60a935e4f9b73eb4bdb855ef9258a1751f10bdc5d"
      },
      "dob": {
        "date": "1992-03-08T15:13:16.688Z",
        "age": 30
      },
      "registered": {
        "date": "2007-07-09T05:51:59.390Z",
        "age": 14
      },
      "phone": "(272) 790-0888",
      "cell": "(489) 330-2385",
      "id": {
        "name": "SSN",
        "value": "405-88-3636"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/75.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
      },
      "nat": "US"
    }
  ],
  "info": {
    "seed": "56d27f4a53bd5441",
    "results": 1,
    "page": 1,
    "version": "1.4"
  }
}
    */

// const query = `INSERT INTO users (first_name, last_name, birthdate, email, password, height, is_subscribe) VALUES ('${user.first_name}', '${user.last_name}', '${user.birthdate}', '${user.email}', '${user.password}', ${user.height}, ${user.is_subscribe});`


function mapUsers(userArray) {
    return userArray.map(({gender, name: {first, last}, email, dob: {date}}) => 
        `('${first}', '${last}', '${email}', '${date}', ${getRandomHeight()}, ${Math.random() > 0.5}, '${gender}')`).join(',');
}

function getRandomHeight() {
    return ((Math.random() * 2) + 1).toFixed(2);
}

module.exports.mapUsers = mapUsers;
