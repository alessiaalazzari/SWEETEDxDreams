// talk_schema.js
const mongoose = require('mongoose');

const talk_schema = new mongoose.Schema({
    _id: String,
    title: String,
    url: String,
    description: String,
    speakers: String,
},
    { collection: 'tedx-versione sonno' });
exports.talk_schema = talk_schema;
