func = require './func'
zmq = require 'zmq'
dsn = func.getConf('zmqreq').dsn

module.exports = 
class reqmq
    @getSock: ->
        oSock = zmq.socket 'req'
        oSock.connect dsn
        oSock
    @msgFormat: (func, params)->
        data = 
            "func": func,
            "params": params
        JSON.stringify(data)