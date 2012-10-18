controller = require "./controller"
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
reqmq = require "#{APP_PATH}/lib/reqmq" # mq fac to get messages from daemon process
sc = {} # sub controllers

module.exports = 
class board extends controller
    render: () ->
        this.boardName = this.req.params.name
        if sc[this.boardName]
            subCtrl = new sc[this.boardName]
            subCtrl.render this
        else
            this.loadBoard()
    loadBoard: ()->
        file = this.getBoardPath()
        self = this
        fs.exists file, (es)->
            if es
                self.res.render file, self.data
            else
                self.res.send "sorry: called board [ #{file} ] not found"
    getBoardPath: ()->
        "#{APP_PATH}/views/board/#{this.boardName}.jade"

class sc.configs
    render: (board)->
        sock = reqmq.getSock()
        sock.on 'message', (reply)->
            reply = reply.toString()
            board.data = 
                configs: reply
            sock.close()
            board.loadBoard()
        func = 'getConfigs'
        params = {}
        sock.send reqmq.msgFormat func, params

class sc.jobs
    render: (board)->
        sock = reqmq.getSock()
        sock.on 'message', (reply)->
            reply = reply.toString()
            board.data = 
                msgcontent: reply
            sock.close()
            board.loadBoard()
        sock.send 'request'
