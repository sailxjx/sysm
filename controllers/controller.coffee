module.exports = 
class controller
    constructor: (req, res)->
        this.req = req
        this.res = res
        this.data = {
            title: 'system backyard'
        }
    render: (req, res) ->
        res.send 'app running'
