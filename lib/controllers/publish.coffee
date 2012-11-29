controller = require "lib/controllers/controller"
db = require "lib/db"
rc = db.loadRedis 'redisPub'

module.exports =
class publish extends controller
    render: ()->
        @res.data.title = 'Publish Platform'
        @loadPubConfs()
    loadPubConfs: ()->
        _this = this
        d = new Date()
        t = parseInt d.getTime()/1000
        rc.multi()
            .hgetall('publish:projects')
            .hgetall('publish:targets')
            .zrangebyscore(['publish:log', t-86400, t])
            .exec (err, replys)->
                projects = {}
                targets = {}
                logList = []
                for i of replys[0]
                    projects[i] = JSON.parse replys[0][i]
                for i of replys[1]
                    targets[i] = JSON.parse replys[1][i]
                for logs in replys[2]
                    logList = logList.concat JSON.parse logs
                _this.data.projects = projects
                _this.data.targets = targets
                _this.data.logList = logList
                _this.res.render 'publish', _this.res.data
