func = require './func'
redis = require 'redis'

module.exports = 
class db
    @loadRedis: ->
        if @oRedis == undefined
            rConf = func.getConf 'redis'
            @oRedis = redis.createClient rConf.port, rConf.host
        @oRedis
