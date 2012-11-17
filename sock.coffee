#!/usr/local/env coffee

express = require 'express'
http = require 'http'
socketio = require 'socket.io'
func = require "lib/func"

app = express()
server = http.createServer app
io = socketio.listen server;
sockPort = func.getConf 'sockPort'
server.listen sockPort
console.log 'socket io listenning on port ' + sockPort

io.sockets.on 'connection', (socket)->
    setInterval (->
        socket.emit 'news', {hello:'world'}), 1000
    socket.on 'myotherevent', (data)->
        console.log data