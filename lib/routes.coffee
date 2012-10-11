fs = require 'fs'

exports.index = (req, res) ->
    res.render 'index', {
        title: 'System backyard'
    }

exports.http404 = (req, res) ->
    res.render 'http404', {
        title: 'Welcome to 404'
    }

exports.board = (req, res) ->
    board = APP_PATH + '/views/board/' + req.params.name
    fs.exists board + '.jade', (es) ->
        if es
            res.render board
        else
            res.send 'this board could not be found'
