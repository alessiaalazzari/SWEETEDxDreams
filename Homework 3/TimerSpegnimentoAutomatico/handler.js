//handler.js
const connectToDb = require('./db');
const VideoTalk = require('./Talk');

// Definizione delle opzioni di timeout predefinite in minuti
const timeoutOptions = {
    '10_minutes': 600000, // 10 minuti
    '20_minutes': 1200000, // 20 minuti
    '30_minutes': 1800000, // 30 minuti
    '40_minutes': 2400000 // 40 minuti
    
};

module.exports.shutdownInactiveTalks = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));

    // Verifica se l'utente ha specificato una delle opzioni di timeout predefinite
    const timeoutKey = event.timeoutOption;
    let timeoutDuration = timeoutOptions[timeoutKey];

    // Verifica se la chiave del timeout è valida, altrimenti utilizza un valore predefinito
    if (!timeoutDuration) {
        console.log('Invalid timeout option, using default.');
        timeoutDuration = timeoutOptions['30_minutes']; // Imposta il timeout predefinito a 10 minuti
    }

    connectToDb().then(() => {
        console.log('=> shutdown inactive talks');

        const currentTime = new Date();

        VideoTalk.find({ isActive: true })
            .then(videoTalks => {
                const videosToTurnOff = videoTalks.filter(video => {
                    return (currentTime - video.startTime) >= timeoutDuration;
                });

                return Promise.all(videosToTurnOff.map(video => {
                    return VideoTalk.findByIdAndUpdate(video._id, { $set: { isActive: false } });
                }));
            })
            .then(() => {
                callback(null, {
                    statusCode: 200,
                    body: 'Inactive talks successfully shutdown.'
                });
            })
            .catch(err => {
                console.error('Error:', err);
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Failed to shutdown inactive talks.'
                });
            });
    });
};
