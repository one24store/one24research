const express = require('express');
const dotenv = require('dotenv');
const Vonage = require('@vonage/server-sdk');
const app = express();
app.use(express.urlencoded({ extended: false }))
dotenv.config({ path: './config/config.env' });

const vonage = new Vonage({
  apiKey: process.env.API_KEY,
  apiSecret: process.env.API_SECRET
});

app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');  
});

app.post('/send_sms', (req, res) => {

    const from = "Node-sms-sender"
    const to = req.body.number;
    const text = req.body.message;

    vonage.message.sendSms(from, to, text, {type: 'unicode'}, (err, responseData) => {
        if (err) {
            console.log(err);
        } else {
            if(responseData.messages[0]['status'] === "0") {
                console.log("Message sent successfully.");
                console.log(responseData);
            } else {
                console.log(`Message failed with error: ${responseData.messages[0]['error-text']}`);
                console.log(responseData);
            }
        }
    })

    res.redirect('/');
})


app.listen(3000,() => console.log('Server started'));