controller = require 'lib/controllers/controller'
libUser = require "lib/user"
func = require "lib/func"

module.exports = 
class login extends controller
    render: () =>
        @res.data.title = 'Login'
        @res.render 'login', @res.data
    before: () =>
        _this = this
        libUser.authCheck _this.req, _this.res, (err, replys)->
            if err?
                _this.render()
            else
                _this.res.redirect func.getConf('baseDomain')