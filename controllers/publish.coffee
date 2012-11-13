controller = require "./controller"
db = require "#{APP_PATH}/lib/db"

module.exports =
class publish extends controller
    render: ()->
        this.data.title = 'Publish Platform'
        this.loadPubConfs()
    loadPubConfs: (callback)->
        rc = db.loadRedis 'redisPub'
        _this = this
        rc.multi()
            .get('publish:projects')
            .get('publish:targets')
            .exec (err, replys)->
                _this.data.projects = JSON.parse replys[0]
                _this.data.targets = JSON.parse replys[1]
                _this.res.render 'publish', _this.data