const express = require('express');
const http = require('http');
const socketio = require('socket.io');

const PORT = 3000;
const app = express();
const server = http.createServer(app);
const io = socketio(server);

app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');  
});

io.on('connection', (socket) => {
    console.log('New websocket communication');
    let id = Math.floor(Math.random() * (10 - 0 + 1)) + 0;// random id bw 0 and 10

    io.emit('joined', id );
    socket.on('disconnect', () => {
        io.emit('left', id)
        console.log('A web socket connection has disconnected');
    })
})

server.listen(PORT, () => {
    console.log(`Server up and running on port ${PORT} !`);
})
  