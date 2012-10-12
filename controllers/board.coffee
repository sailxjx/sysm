controller = require "./controller"
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
sc = {} # board controllers

module.exports = 
class board extends controller
    render: () ->
        this.boardName = this.req.params.name
        if sc[this.boardName]
            subCtrl = new sc[this.boardName]
            subCtrl.render this, this.loadBoard
        else
            this.loadBoard()
    loadBoard: ()->
        file = this.getBoardPath()
        self = this
        fs.exists file, (es)->
            if es
                self.res.render file, self.data
            else
                self.res.send "sorry: called board [ #{file} ] not found"
    getBoardPath: ()->
        "#{APP_PATH}/views/board/#{this.boardName}.jade"

class sc.configs
    render: (board)->
        redis = db.loadRedis()
        args = ['notice:mail:table:6', 'content']
        redis.hget args, (err, data)->
            board.data = {
                mailcontent: data
            }
            board.loadBoard()
