//Talk.js
const mongoose = require('mongoose');
const { videoTalkSchema } = require('./talk_schema');

module.exports = mongoose.model('VideoTalk', videoTalkSchema);
