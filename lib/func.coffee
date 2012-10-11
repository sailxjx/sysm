fs = require 'fs'

module.exports = class func
    @loadCtl: (ctl, req, res) ->

    @reqFile: (file)->
        st = false
        fs.exists file, (es)->
            st = es

    @reqCtl: (ctl)->
        file = APP_PATH + '/controllers/' + ctl + '.coffee'
        this.reqFile file
