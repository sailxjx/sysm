admin = require 'lib/controllers/admin/admin'
func = require 'lib/func'

module.exports =
class user extends admin
    render: ()=>
        action = @req.params.action
        if func.empty this[action]
            func.applyCtrl 'http404', @req, @res
        else
            this[action]()
    add: ()->
        @res.render 'admin/user/add', @res.data
