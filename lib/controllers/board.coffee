controller = require "lib/controllers/controller"
db = require "lib/db"
reqmq = require "lib/reqmq" # mq fac to get messages from daemon process
func = require "lib/func"
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
        for i of data
            @data[i] = data[i]
        try
            @res.render "board/#{@boardName}", @data
        catch e
            console.log e
            @res.send "sorry: called board [ board/#{@boardName} ] not found"

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

# get mail channels
class sc.mailchannels
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailChannels').reply (reply)->
            reply = JSON.parse reply.toString()
            mailChannels = {}
            if !func.empty(reply.data)
                for i of reply.data
                    mailChannels[i] = JSON.parse reply.data[i]
            data = 
                mailChannels: mailChannels
                boardTitle: 'Mail Channels'
            callback data

# get mail templates
class sc.mailtemplates
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailTempSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                mailTemplates: reply.data
                boardTitle: 'Mail Templates'
            callback data
