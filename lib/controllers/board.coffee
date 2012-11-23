controller = require "lib/controllers/controller"
db = require "lib/db"
reqmq = require "lib/reqmq" # mq fac to get messages from daemon process
func = require "lib/func"
sc = {} # sub controllers

module.exports =
class board extends controller
    render: ->
        @data.boardName = @req.params.name
        @data.boardTitle = 'board'
        if sc[@data.boardName]
            subCtrl = new sc[@data.boardName] @req, @res
            subCtrl.render this.loadBoard
        else
            this.loadBoard()
    loadBoard: (data)=>
        for i of data
            @data[i] = data[i]
        try
            @res.render "board/#{@data.boardName}", @data
        catch e
            console.log e
            @res.send "sorry: called board [ board/#{@data.boardName} ] not found"

class scbase
    constructor: (req, res)->
        @req = req
        @res = res

# get job status
class sc.joblist extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getJobList').reply (reply)->
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
            data = 
                boardTitle: 'Job Summary'
                jobNum: reply.data
            callback data

# get mail summary
class sc.mailsum extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailSum').reply (reply)->
            data = 
                mailSum: reply.data
                boardTitle: 'Mail Summary'
            callback data

# get mail channels
class sc.mailchannels extends scbase
    render: (callback)->
        oReqmq = new reqmq()
        oReqmq.send('getMailChannels').reply (reply)->
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
            for i in reply.data
                i.utime = func.tsToDate i.utime
            data = 
                mailTemplates: reply.data
                boardTitle: 'Mail Templates'
            callback data

class sc.mailtempedit extends scbase
    render: (callback)->
        mailname = @req.query.mailname
        boardTitle = 'Mail Template Editor'
        if func.empty mailname
            data =
                mailTemplates: null
                boardTitle: boardTitle
                boardName: 'mailtempadd'
            callback data
        else
            oReqmq = new reqmq()
            oReqmq.send('getMailTemp', {
                name: mailname
                }).reply (reply)->
                reply.data = {} if func.empty reply.data
                reply.data.webpowerid = '' if func.empty(reply.data.webpowerid)
                data =
                    mailTemplate: reply.data
                    boardTitle: boardTitle
                callback data

class sc.heartbeatconfigs extends scbase
    render: (callback)->
        callback {
            boardTitle: 'Heartbeat Configs - 目前仅支持163邮箱'
        }