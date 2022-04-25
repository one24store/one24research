const unirest = require("unirest");
const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config()
app.use(express.urlencoded({ extended: false }))
app.use(cors())

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');  
  console.log(process.env.API_KEY);
});

app.post('/send_sms', (req, res) => {
  let reqSend = unirest("POST", "https://www.fast2sms.com/dev/bulkV2");

  reqSend.headers({
    "authorization": process.env.API_KEY
  });

  reqSend.form({
    "sender_id": "Cghpet",
    "message": req.body.message,
    "language": "english",
    "route": "v3",
    "numbers": req.body.number, // can be multiple numbers
  });

  reqSend.end((res) => {
    if (res.error) throw new Error(res.error);

    console.log(res.body);
  });
})

app.listen(5000)




