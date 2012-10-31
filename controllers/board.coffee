controller = require "./controller"
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
reqmq = require "#{APP_PATH}/lib/reqmq" # mq fac to get messages from daemon process
func = require "#{APP_PATH}/lib/func"
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

# get job status
class sc.joblist
    render: (board)->
        sock = reqmq.getSock()
        sock.send reqmq.msgFormat 'getJobList'
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.boardTitle = 'Job List'
            if reply.status == 1
                jobList = reply.data
                for i of jobList
                    jobList[i].starttime = func.tsToDate(jobList[i].start)
                board.data.jobList = jobList
            else
                board.data.jobList = null
            sock.close()
            board.loadBoard()

# get job summary
class sc.jobsum
    render: (board)->
        sock = reqmq.getSock()
        sock.send reqmq.msgFormat 'getJobSum'
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.jobNum = reply.data
            board.data.boardTitle = 'Job Summary'
            sock.close()
            board.loadBoard()

# get mail summary
class sc.mailsum
    render: (board)->
        sock = reqmq.getSock()
        sock.send reqmq.msgFormat 'getMailSum'
        sock.on 'message', (reply)->
            reply = JSON.parse reply.toString()
            board.data.mailSum = reply.data
            board.data.boardTitle = 'Mail Summary'
            board.loadBoard()
