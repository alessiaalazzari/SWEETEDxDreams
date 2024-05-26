//talk_schema.js
const mongoose = require('mongoose');

const videoTalkSchema = new mongoose.Schema({
    _id: String,
    title: String,
    url: String,
    description: String,
    speakers: String,
}, { collection: 'tedx-versione sonno' });

exports.videoTalkSchema = videoTalkSchema;


