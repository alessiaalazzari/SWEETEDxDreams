// Talk.js
const mongoose = require('mongoose');
const { talk_schema } = require('./talk_schema');

module.exports = mongoose.model('talk', talk_schema);
