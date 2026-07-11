// Passenger entry for Beget (danilagames.ru/expansion_api)
process.env.PASSENGER_NODEJS =
  '/home/a/autogie1/danilagames.ru/node-v18.19.0-linux-x64/bin/node';

require('dotenv').config();

const app = require('./api/server');
const port = Number(process.env.PORT || 3000);

app.listen(port);

module.exports = app;
