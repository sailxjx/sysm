controller = require "./controller"
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
reqmq = require "#{APP_PATH}/lib/reqmq" # mq fac to get messages from daemon process
func = require "#{APP_PATH}/lib/func"
sc = {} # sub controllers

module.exports =
class board extends controller
    render: ->
        this.boardName = this.req.params.name
        this.data.boardTitle = 'board'
        if sc[this.boardName]
            subCtrl = new sc[this.boardName]
            subCtrl.render this.loadBoard
        else
            this.loadBoard()
    loadBoard: (data)=>
        file = this.getBoardPath()
        for i of data
            this.data[i] = data[i]
        _this = this
        fs.exists file, (es)->
            if es
                _this.res.render file, _this.data
            else
                _this.res.send "sorry: called board [ #{file} ] not found"
    getBoardPath: =>
        "#{APP_PATH}/views/board/#{this.boardName}.jade"

# get job status
class sc.joblist
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getJobList').reply (reply)->
            reply = JSON.parse reply.toString()
            data =
                boardTitle: 'Job List'
            if reply.status == 1
                jobList = reply.data
                for i of jobList
                    jobList[i].starttime = func.tsToDate jobList[i].start
                data.jobList = jobList
            else
                data.jobList = null
            callback data

# get job summary
class sc.jobsum
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getJobSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                boardTitle: 'Job Summary'
                jobNum: reply.data
            callback data

# get mail summary
class sc.mailsum
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                mailSum: reply.data
                boardTitle: 'Mail Summary'
            callback data