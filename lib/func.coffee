fs = require 'fs'

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
        file = "#{APP_PATH}/controllers/#{ctrl}.coffee"
        fs.exists file, (es)->
            if es
                oCtrl = require file
                eCtrl = new oCtrl req, res
                eCtrl.render()
            else
                throw "error: called controller [ #{file} ] not found! "
    @getConf: (key)->
        configs = this.loadConf()
        configs[key]
    @loadConf: ->
        if @configs == undefined
            confPath = "#{APP_PATH}/config/config.json"
            @configs = JSON.parse fs.readFileSync confPath, 'UTF-8'
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