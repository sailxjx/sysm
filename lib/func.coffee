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
    @loadCtrl: (ctrl, req, res) ->
        try
            oCtrl = require "lib/ctl/#{ctrl}.coffee"
            eCtrl = new oCtrl req, res
            eCtrl.render()
        catch e
            console.log e
            throw "error: called controller [ #{file} ] not found! "
    @getConf: (key)->
        configs = this.loadConf()
        configs[key]
    @loadConf: ->
        if @empty @configs
            env = process.env.NODE_ENV
            env = 'dev' if @empty env
            try
                @configs = require "configs/#{env}.json"
            catch e
                throw "error: called config [ #{env} ] not found! "
        @configs
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