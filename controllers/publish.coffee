controller = require "./controller"
db = require "#{APP_PATH}/lib/db"
rc = db.loadRedis 'redisPub'

module.exports =
class publish extends controller
    render: ()->
        this.data.title = 'Publish Platform'
        this.loadPubConfs()
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
                for i of replys[0]
                    projects[i] = JSON.parse replys[0][i]
                for i of replys[1]
                    targets[i] = JSON.parse replys[1][i]
                for i of logs
                    oLog = JSON.parse logs[i]
                    for log in oLog
                        logList.push log
                _this.data.projects = projects
                _this.data.targets = targets
                _this.data.logList = replys[2]
                _this.res.render 'publish', _this.data
