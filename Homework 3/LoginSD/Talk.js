//Talk.js
const mongoose = require('mongoose');

const talk_schema = new mongoose.Schema({
    _id: String,
    Mail: String,
    Username: String,
    Password: String,
}, { collection: 'tedx-data-login' });

module.exports = mongoose.model('talk', talk_schema);
