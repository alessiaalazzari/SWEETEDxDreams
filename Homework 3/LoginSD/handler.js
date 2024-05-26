//handler.js
const connect_to_db = require('./db');

// LOGIN HANDLER

const talk = require('./Talk');

module.exports.loginutente = (event, context, callback) => {
    context.callbackWaitsForEmptyEventLoop = false;
    console.log('Received event:', JSON.stringify(event, null, 2));
    let body = {}
    if (event.body) {
        body = JSON.parse(event.body)
    }
    // set default
    if(!body.mail) {
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Mail is null.'
        })
    }
    if(!body.password) {
        callback(null, {
                statusCode: 500,
                headers: { 'Content-Type': 'text/plain' },
                body: 'Password is null.'
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
        talk.findOne({ "Mail": body.mail, "Password": body.password })
            .then(user => {
                if (!user) {
                    console.log('=> User not found');
                    return callback(null, {
                        statusCode: 404,
                        headers: { 'Content-Type': 'text/plain' },
                        body: 'User not found.'
                    });
                }
                console.log('=> User found:', user);
                callback(null, {
                    statusCode: 200,
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ "Mail": user.Mail, "Username": user.Username, "Password": user.Password })
                });
            })
            .catch(err => {
                console.error('Database query failed:', err);
                callback(null, {
                    statusCode: 500,
                    headers: { 'Content-Type': 'text/plain' },
                    body: 'Could not fetch the user.'
                });
            });
    }).catch(err => {
        console.error('Database connection failed:', err);
        callback(null, {
            statusCode: 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Database connection failed.'
        });
    });

};
