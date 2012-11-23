func = require "lib/func"
libUser = require "lib/user"

module.exports = 
class controller
    constructor: (req, res)->
        @req = req
        @res = res
        @data = {
            title: 'System Backyard'
            baseDomain: func.getConf 'baseDomain'
        }
    render: () =>
        @res.send 'app running'
    before: () =>
        _this = this
        libUser.authCheck _this.req, _this.res, (err, replys)->
            if err?
                func.applyCtrl 'login', _this.req, _this.res, 'render'
            else
                _this.render()