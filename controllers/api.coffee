controller = require "./controller"
url = require "url"
func = require "#{APP_PATH}/lib/func"
reqmq = require "#{APP_PATH}/lib/reqmq"
db = require "#{APP_PATH}/lib/db"
rc = db.loadRedis 'redisPub'

module.exports = 
class api extends controller
    render: =>
        action = this.req.params.action
        if this[action]
            this[action]()
        else
            this.res.send func.errReply 'error', 'could not find the called api action'
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
        pname = this.req.query.pname
        _this = this
        if pname
            rc.get 'publish:projects', (err, replys)->
                projects = JSON.parse replys
                if projects[pname]?
                    project = projects[pname]
                else
                    _this.res.send "error: pname[#{pname}] not found"
        else
            _this.res.send "error: please give me the pname"