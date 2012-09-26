#!/usr/local/env coffee

express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'

app = express()
app.configure () ->
    app.set 'port', 3000
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use express.static path.join __dirname, 'public'

app.get '/', routes.index

http.createServer(app).listen app.get('port'), ()->
    console.log "listening on port " + app.get 'port'
