crypto = require 'crypto'

Date.prototype.format = (format)->
    od = 
        "y+": this.getFullYear() # get full year (2012)
        "M+": this.getMonth() + 1 # get month (10)
        "d+": this.getDate() # get date (31)
        "h+": this.getHours() # get hours (11)
        "m+": this.getMinutes() # get minutes (31)
        "s+": this.getSeconds() # get seconds (59)
    for i of od
        if new RegExp("(" + i + ")").test format
            format = format.replace RegExp.$1, od[i]
    format

module.exports =
class func
    @applyCtrl = (ctrl, req, res, method=null)->
        try
            oCtrl = require "lib/controllers/#{ctrl}"
            eCtrl = new oCtrl req, res
            if method?
                eCtrl[method]()
            else
                eCtrl.before()
        catch e
            console.log e
            throw "error: called controller [ #{ctrl} ] not found! "        
    @getConf: (key)->
        configs = @loadConf()
        configs[key]
    @loadConf: ->
        if @empty @configs
            env = process.env.NODE_ENV
            env = 'dev' if @empty env
            try
                @configs = require "configs/#{env}"
            catch e
                throw "error: called config [ #{env} ] not found! "
        @clone @configs
    @tsToDate: (timestamp, format = 'yyyy-MM-dd hh:mm:ss')->
        oDate = new Date(timestamp * 1000)
        oDate.format(format)
    @succReply: (data, msg='succ')->
        reply=
            status: 1
            data: data
            msg: msg
        JSON.stringify reply
    @errReply: (data, msg='error')->
        reply=
            status: 0
            data: data
            msg: msg
        JSON.stringify reply
    @empty: (v)->
        switch typeof v
            when "undefined" then return true
            when "string" then return true if v.trim() == ""
            when "object" then return true if v == null || v.length == 0
            when "number" then return true if v == 0
            else return false
        false
    @setCookie: (res, name, value)->
        cookieConf = @getConf 'cookie'
        confTmp = cookieConf
        confTmp.expires = new Date(Date.now() + cookieConf.expires * 1000)
        res.cookie name, value, confTmp
    @getCookie: (req, name)->
        if @empty req.cookies[name] then return null else return req.cookies[name]
    @send500: (res)->
        res.send 'something error'
    @send404: (res)->
        # @todo send404
    @md5: (str)->
        if @empty str
            return ''
        crypto.createHash('md5').update(str.toString()).digest('hex')
    @genPwd: (plainPwd, salt = '')->
        @md5(plainPwd + salt).substr 7,20
    @genSalt: ()->
        @md5(Math.random()).substr 7,6
    @genCookieVerify: (user)->
        if @empty(user.salt) || @empty(user.name)
            return false
        @md5(user.name.toString() + user.salt.toString()).substr 7, 16
    @clone: (obj)->
        JSON.parse(JSON.stringify(obj))
