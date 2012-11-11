controller = require './controller'
func = require "#{APP_PATH}/lib/func"

module.exports = 
class index extends controller
    render: () ->
        boards = func.getConf 'boards'
        for board in boards
            if board.size == undefined then board.size = 'small'
        this.data.boards = boards
        this.res.render 'index', this.data
