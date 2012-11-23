controller = require "lib/controllers/controller"
url = require "url"
func = require "lib/func"
reqmq = require "lib/reqmq"
db = require "lib/db"
rc = db.loadRedis()
spub = require "lib/spub"

module.exports = 
class api extends controller
    render: =>
        action = @req.params.action
        if this[action]
            this[action]()
        else
            @errReply 'error', 'could not find the called api action'
    startjob: ->
        cmd = @req.query.cmd
        if func.empty cmd
            @errReply 'error', 'missing cmd params'
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
        @res.send func.errReply data, msg
    succReply: (data, msg='succ')=>
        @res.send func.succReply data, msg
    reg: ->
        user = @req.query.user
        if user.pwd != user.pwdrepeat || func.empty user.pwd
            @errReply 'error', 'password error'
            return false
        salt = func.genSalt()
        userData =
            name: user.name
            pwd: func.genPwd user.pwd, salt
            salt: salt
        _this = this
        rc.hmset "user:#{userData.name}", userData, (err, replys)->
            console.log err if err?
            if err?
                _this.errReply replys, 'reg fail'
            else
                _this.succReply replys, 'reg succ'
    mailtempedit: ()->
        method = @req.params.method
        _this = this
        if method != 'post'
            _this.errReply @req.params, 'api method error!'
        if func.empty @req.body.name
            _this.errReply @req.body, 'mail name should not be empty!'
        oReqmq = new reqmq()
        oReqmq.send('setMailTemp', @req.body).reply (reply)->
            _this.res.send reply
    mailchanneledit: ()->
        _this = this
        oReqmq = new reqmq()
        oReqmq.send('setMailService', @req.query).reply (reply)->
            _this.res.send reply
