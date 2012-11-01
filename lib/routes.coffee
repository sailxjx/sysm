func = require "#{APP_PATH}/lib/func"

exports.index = (req, res) ->
    func.loadCtrl 'index', req, res

exports.http404 = (req, res) ->
    func.loadCtrl 'http404', req, res

exports.board = (req, res) ->
    func.loadCtrl 'board', req, res

exports.api = (req, res) ->
    func.loadCtrl 'api', req, res

exports.url = (req, res)->
    func.loadCtrl 'url', req, res
