controller = require 'lib/controllers/controller'
func = require "lib/func"

module.exports = 
class index extends controller
    render: () ->
        boards = func.getConf 'boards'
        for board in boards
            if board.size == undefined then board.size = 'small'
        @data.boards = boards
        @res.render 'index', @data