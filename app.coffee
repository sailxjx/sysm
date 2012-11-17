#!/usr/local/env coffee

express = require 'express'
routes = require "lib/routes"
http = require 'http'
path = require 'path'
func = require "lib/func"

app = express()

app.set 'port', func.getConf 'port'
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

app.get '/', routes.index
app.get '/pub/?', routes.publish
app.get '/board/:name/?', routes.board
app.get '/api/:action/?', routes.api
app.get '/url/(:surl)?', routes.url

server = http.createServer(app)
server.listen app.get('port'), ()->
    console.log "listening on port " + app.get 'port'
