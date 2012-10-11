module.exports = 
class Db
    @loadRedis: ->
        if @oRedis == undefined
            @oRedis = require('redis').createClient 6379, '127.0.0.1'
        @oRedis
