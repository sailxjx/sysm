func = require './func'
zmq = require 'zmq'
dsn = func.getConf('zmqReq').dsn

module.exports = 
class reqmq
    getSock: ->
        if @oSock == undefined
            @oSock = zmq.socket 'req'
            @oSock.connect dsn
        @oSock
    msgFormat: (func, params = {})->
        data = 
            "func": func,
            "params": params
        JSON.stringify(data)
    send: (func, params = {})->
        oSock = this.getSock()
        oSock.send this.msgFormat func, params
        this
    reply: (callback)->
        oSock = this.getSock()
        oSock.on 'message', (data)->
            oSock.close()
            callback data