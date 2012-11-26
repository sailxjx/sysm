db = require 'lib/db'
func = require 'lib/func'
rc = db.loadRedis()

exports.authCheck = (req, res, callback)->
    username = func.getCookie req, 'username'
    cookieVerify = func.getCookie req, 'cookieverify'
    if func.empty(username) || func.empty(cookieVerify)
        callback 'username or cookieverify not exist', null
    else
        rc.hgetall "user:#{username}", (err, replys)->
            if err?
                console.log err
                callback err, null
            else
                salt = replys.salt
                if func.genCookieVerify({name: username, salt: salt}) != cookieVerify
                    callback 'cookie check fail', null
                else
                    callback null, replys

exports.login = (req, res, user, callback)->
    if func.empty user.name
        callback 'username empty', null
        return false
    fields = ['name', 'pwd', 'salt']
    rc.hmget "user:#{user.name}", fields, (err, replys)->
        if err?
            console.log err
            callback err, null
        else
            [name, pwd, salt] = replys
            if func.genPwd(user.pwd, salt) == pwd
                cookieVerify = func.genCookieVerify {
                    name: name
                    salt: salt
                }
                func.setCookie res, 'username', name
                func.setCookie res, 'cookieverify', cookieVerify
                callback err, replys
            else
                callback 'login fail', null