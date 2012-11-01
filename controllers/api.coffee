controller = require "./controller"
url = require "url"
func = require "#{APP_PATH}/lib/func"
reqmq = require "#{APP_PATH}/lib/reqmq"

module.exports = 
class api extends controller
    render: ->
        action = this.req.params.action
        if this[action]
            this[action]()
        else
            this.res.send func.errReply 'error', 'could not find the called api action'
    startJob: ->
        cmd = this.req.query.cmd
        if cmd == undefined
            this.res.send func.errReply 'error', 'missing cmd params'
            return false
        else
            sock = reqmq.getSock()
            sock.send reqmq.msgFormat 'startJob', this.req.query
            _this = this
            sock.on 'message', (reply)->
                _this.res.send reply.toString()