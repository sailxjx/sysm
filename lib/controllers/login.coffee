controller = require 'lib/controllers/controller'
user = require "lib/user"
func = require "lib/func"

module.exports = 
class login extends controller
    render: () =>
        @data.title = 'Login'
        @res.render 'login', @data
    before: () =>
        _this = this
        user.authCheck _this.req, _this.res, (userInfo)->
            if func.empty userInfo
                _this.render()
            else
                _req.userInfo = userInfo
                func.applyCtrl 'index', _this.req, _this.res