db = require 'lib/db'
rc = db.loadRedis()
rc.hmset 'user', {'name':'sailxjx', 'pwd':'1111111'}, (err, reply)->
    console.log(err)
    console.log(reply)
