db = require 'lib/db'
func = require 'lib/func'
rc = db.loadRedis()

exports.authCheck = (req, res, callback)->
    username = func.getCookie req, 'username'
    if func.empty username
        callback null