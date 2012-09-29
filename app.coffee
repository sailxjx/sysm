#!/usr/local/env coffee

express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
rc = require('./lib/db').loadRedis()

n = null
for i in [0..100000]
    rc.zadd 'zset', new Date().getTime(), i, ()->
        n++

# process.exit()

# args = ['zset', 0, 10000, 'WITHSCORES']
# rc1.zrange args, (err, rep) ->
#     console.log rep

# process.exit()

# app = express()
# app.configure () ->
#     app.set 'port', 3000
#     app.set 'views', __dirname + '/views'
#     app.set 'view engine', 'jade'
#     app.use express.favicon()
#     app.use express.logger 'dev'
#     app.use express.bodyParser()
#     app.use express.methodOverride()
#     app.use app.router
#     app.use express.static path.join __dirname, 'public'

# app.get '/', routes.index

# http.createServer(app).listen app.get('port'), ()->
#     console.log "listening on port " + app.get 'port'
