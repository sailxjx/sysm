fs = require 'fs'

module.exports = 
class func
    @loadCtrl: (ctrl, req, res) ->
        file = APP_PATH + '/controllers/' + ctrl + '.coffee'
        fs.exists file, (es)->
            if es
                oCtrl = require file
                eCtrl = new oCtrl req, res
                eCtrl.render()
            else
                throw "error: called controller [ #{file} ] not found! "
