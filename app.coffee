#!/usr/local/env coffee

global.APP_PATH = __dirname
express = require 'express'
routes = require "#{APP_PATH}/lib/routes"
http = require 'http'
path = require 'path'

app = express()

init = (app) ->
    app.set 'port', 3000
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'
    app.use express.logger 'dev',
    app.use express.bodyParser()
    app.use express.favicon()
    app.use express.methodOverride()
    app.use express.cookieParser()
    app.use app.router
    app.use express.static path.join __dirname, 'public'
    app.use routes.http404

appRouter = (app) ->
    app.get '/', routes.index
    app.get '/board/:name', routes.board

appStart = (app) ->
    server = http.createServer(app)
    server.listen app.get('port'), ()->
        console.log "listening on port " + app.get 'port'

init app
appRouter app
appStart app
