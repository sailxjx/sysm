func = require './func'
redis = require 'redis'

module.exports = 
class db
    @oRedis: {}
    @loadRedis: (conf = 'redis')->
        if @oRedis[conf] == undefined
            rConf = func.getConf conf
            @oRedis[conf] = redis.createClient rConf.port, rConf.host
        @oRedis[conf]
