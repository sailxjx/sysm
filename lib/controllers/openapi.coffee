controller = require "lib/controllers/controller"
func = require "lib/func"
db = require 'lib/db'
rc = db.loadRedis()
libUser = require 'lib/user'

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
    login: ->
        user = @req.query.user
        _this = this
        libUser.login @req, @res, user, (err, replys)->
            if err?
                _this.errReply null, 'login fail'
            else
                _this.succReply null, 'login succ'