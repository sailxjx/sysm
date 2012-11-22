controller = require "lib/controllers/controller"
db = require "lib/db"
reqmq = require "lib/reqmq" # mq fac to get messages from daemon process
func = require "lib/func"
sc = {} # sub controllers

module.exports =
class board extends controller
    render: ->
        @boardName = @req.params.name
        @data.boardTitle = 'board'
        if sc[this.boardName]
            subCtrl = new sc[this.boardName] @req, @res
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

class scbase
    constructor: (req, res)->
        @req = req
        @res = res

# get job status
class sc.joblist extends scbase
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
class sc.jobsum extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getJobSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                boardTitle: 'Job Summary'
                jobNum: reply.data
            callback data

# get mail summary
class sc.mailsum extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                mailSum: reply.data
                boardTitle: 'Mail Summary'
            callback data

# get mail channels
class sc.mailchannels extends scbase
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
class sc.mailtemplates extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailTempSum').reply (reply)->
            reply = JSON.parse reply.toString()
            data = 
                mailTemplates: reply.data
                boardTitle: 'Mail Templates'
            callback data

class sc.mailtempedit extends scbase
    render: (callback)->
        mailname = @req.query.mailname
        oReqmq = new reqmq()
        oReqmq.send('getMailTemp', {
            name: mailname
            }).reply (reply)->
            reply = JSON.parse reply.toString()
            reply.data = {} if func.empty reply.data
            data =
                mailTemplate: reply.data
                boardTitle: 'Mail Template Editor'
            callback data
