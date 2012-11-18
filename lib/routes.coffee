func = require 'lib/func'

exports.default = (req, res)->
    controller = req.url.split('/')[1]
    if func.empty controller
        func.applyCtrl 'http404', req, res
    else
        func.applyCtrl controller, req, res

exports.index = (req, res) ->
    func.applyCtrl 'index', req, res

exports.http404 = (req, res) ->
    func.applyCtrl 'http404', req, res

exports.admin = (req, res)->
    func.applyCtrl "admin/#{req.params.controller}", req, res

exports.publish = (req, res)->
    func.applyCtrl 'publish', req, res