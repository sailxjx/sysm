controller = require 'lib/controllers/controller'
func = require "lib/func"

module.exports = 
class index extends controller
    render: () ->
        user = @req.dbData.user
        if user.role == 'admin'
            boards = func.getConf 'boards'
            for board in boards
                if board.size == undefined then board.size = 'medium'
        else
            boards = null
        @data.boards = boards
        @res.render 'index', @data