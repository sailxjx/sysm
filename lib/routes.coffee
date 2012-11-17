func = require 'lib/func'

exports.index = (req, res) ->
    func.applyCtrl 'index', req, res

exports.login = (req, res) ->
    func.applyCtrl 'login', req, res

exports.http404 = (req, res) ->
    func.applyCtrl 'http404', req, res

exports.board = (req, res) ->
    func.applyCtrl 'board', req, res

exports.api = (req, res) ->
    func.applyCtrl 'api', req, res

exports.openapi = (req, res) ->
    func.applyCtrl 'openapi', req, res

exports.url = (req, res)->
    func.applyCtrl 'url', req, res

exports.publish = (req, res)->
    func.applyCtrl 'publish', req, res