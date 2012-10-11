controller = require './controller'
fs = require 'fs'

module.exports = 
class board extends controller
    render: () ->
        boardName = this.req.params.name
        this.loadBoard boardName
    loadBoard: (boardName)->
        file = this.getBoardFile boardName
        req = this.req
        res = this.res
        fs.exists file, (es)->
            if es
                res.render file
            else
                res.send "error: called boardName [ #{file} ] not found! "
    getBoardFile: (boardName) ->
        return APP_PATH + "/views/board/#{boardName}.jade"
