class db
    loadRedis: ->
        redis = require 'redis'
        rc = redis.createClient 6379, '127.0.0.1'