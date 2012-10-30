controller = require "./controller"
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
reqmq = require "#{APP_PATH}/lib/reqmq" # mq fac to get messages from daemon process
sc = {} # sub controllers

module.exports = 
class board extends controller
    render: () ->
        this.boardName = this.req.params.name
        this.data.boardTitle = 'board'
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

# get configs
class sc.configs
    render: (board)->
        sock = reqmq.getSock()
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.configs = reply.data
            sock.close()
            board.loadBoard()
        sock.send reqmq.msgFormat 'getConfigs'

# get job status
class sc.jobs
    render: (board)->
        sock = reqmq.getSock()
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.msgContent = reply.data
            sock.close()
            board.loadBoard()
        sock.send reqmq.msgFormat 'getJobs'

# get job summary
class sc.jobsum
    render: (board)->
        sock = reqmq.getSock()
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.jobNum = reply.data
            sock.close()
            board.loadBoard()
        sock.send reqmq.msgFormat 'getJobSum'

# get mail summary
class sc.mailsum
    render: (board)->
        board.loadBoard()