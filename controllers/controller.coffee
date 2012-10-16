func = require "#{APP_PATH}/lib/func"

module.exports = 
class controller
    constructor: (req, res)->
        this.req = req
        this.res = res
        this.data = {
            title: 'system backyard',
            basedomain: func.getConf 'basedomain'
        }
    render: (req, res) ->
        res.send 'app running'
