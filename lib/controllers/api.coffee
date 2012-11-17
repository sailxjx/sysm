controller = require "lib/controllers/controller"
url = require "url"
func = require "lib/func"
reqmq = require "lib/reqmq"
db = require "lib/db"
rc = db.loadRedis 'redisPub'
spub = require "lib/spub"

module.exports = 
class api extends controller
    render: =>
        action = this.req.params.action
        if this[action]
            this[action]()
        else
            @errReply 'error', 'could not find the called api action'
    startjob: ->
        cmd = this.req.query.cmd
        if cmd
            this.res.send func.errReply 'error', 'missing cmd params'
            return false
        else
            oReqmq = new reqmq()
            _this = this
            oReqmq.send('startJob',this.req.query).reply (reply)->
                _this.res.send reply.toString()
    publish: ->
        params = this.req.query
        _this = this
        if params.timestamp? then params.timestamp = true else params.timestamp = false
        spub params, (err, data)->
            if err?
                _this.errReply data, err.toString()
            else
                _this.succReply data, 'success: project has been successfully published.'
    errReply: (data, msg='error')=>
        this.res.send func.errReply data, msg
    succReply: (data, msg='succ')=>
        this.res.send func.succReply data, msg