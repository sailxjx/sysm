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
        rc.multi()
            .hgetall('publish:projects')
            .hgetall('publish:targets')
            .exec (err, replys)->
                projects = {}
                targets = {}
                for i of replys[0]
                    projects[i] = JSON.parse replys[0][i]
                for i of replys[1]
                    targets[i] = JSON.parse replys[1][i]
                _this.data.projects = projects
                _this.data.targets = targets
                _this.res.render 'publish', _this.data
