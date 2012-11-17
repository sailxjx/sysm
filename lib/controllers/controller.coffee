func = require "lib/func"
user = require "lib/user"

module.exports = 
class controller
    constructor: (req, res)->
        @req = req
        @res = res
        @data = {
            title: 'System Backyard - "SB" for short?'
            baseDomain: func.getConf 'baseDomain'
        }
    render: () =>
        @res.send 'app running'
    before: () =>
        _this = this
        user.authCheck _this.req, _this.res, (userInfo)->
            if func.empty userInfo
                func.applyCtrl 'login', _this.req, _this.res, 'render'
            else
                _this.req.userInfo = userInfo
                _this.render()