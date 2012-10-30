func = require "#{APP_PATH}/lib/func"

module.exports = 
class controller
    constructor: (req, res)->
        this.req = req
        this.res = res
        this.data = {
            title: 'System Backyard - "SB" for short?'
            baseDomain: func.getConf 'baseDomain'
        }
    render: (req, res) ->
        res.send 'app running'
