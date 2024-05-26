// handler.js
const connect_to_db = require('./db');

// GET BY ID HANDLER

const talk = require('./Talk');

module.exports.get_by_idx = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    // set default
    if(!body.idx) {
        callback(null, {
                    statusCode: 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks. Tag is null.'
        })
    }
    
    if (!body.doc_per_page) {
        body.doc_per_page = 10
    }
    if (!body.page) {
        body.page = 1
    }
    
    connect_to_db().then(() => {
        console.log('=> get_all talks');
        talk.find({ _id: body.idx }, { WatchNext_id: 1, WatchNext_title: 1 })
            .then(talks => {
                if (!talks) {
                    throw new Error('Talk not found');
                }
                callback(null, {
                    statusCode: 200,
                    body: JSON.stringify(talks)
                })
            }
            )
            .catch(err =>
                callback(null, {
                    statusCode: err.statusCode || 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the talks.'
                })
            );
    });
};