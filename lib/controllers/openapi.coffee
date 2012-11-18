controller = require "lib/controllers/controller"
func = require "lib/func"
db = require 'lib/db'
rc = db.loadRedis()

module.exports = 
class openapi extends controller
    render: =>
        action = @req.params.action
        if this[action]
            this[action]()
        else
            @errReply 'error', 'could not find the called api action'
    errReply: (data, msg='error')=>
        @res.send func.errReply data, msg
    succReply: (data, msg='succ')=>
        @res.send func.succReply data, msg
    before: ->
        action = @req.params.action
        if action == 'before'
            @errReply 'error', "called the invalid action [ #{action} ]"
        else
            @render()
    reg: ->
        user = @req.query.user
        console.log user
        _this = this
        rc.hmset "user:#{user.name}", user, (err, replys)->
            console.log err if err?
            _this.succReply replys, 'reg succ'
    login: ->
        @succReply()