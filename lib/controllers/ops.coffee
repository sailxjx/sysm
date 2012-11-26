controller = require 'lib/controllers/controller'
libUser = require "lib/user"
func = require "lib/func"
fs = require 'fs'
reqmq = require "lib/reqmq"
verFile = __dirname + '/../../var/version'

module.exports =
class ops extends controller
    render: () =>
        @data.title = 'Ops'
        @data.version = {}
        @data.version.sysm = @getVersion()
        @getSysdVersion()
    getVersion: ->
        try
            version = fs.readFileSync(verFile).toString()
        catch e
            version = ''
        version
    getSysdVersion: ->
        _this = this
        oReqmq = new reqmq()
        oReqmq.send('getNightlyVersion').reply (reply)->
            _this.data.version.sysd = reply.data
            _this.res.render 'ops', _this.data