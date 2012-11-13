exec = require('child_process').exec
fs = require 'fs'

pubdata =
    prefix: '/tmp/pub/'
    username: 'hudson'
    password: 'JvjLYFIr'

pname = 'fun'
project =
    vcs: 'svn'
    url: 'svn://192.168.0.178/fun'
    dir: '/usr/local/webdata/fun'

localDir = pubdata.prefix + pname
if fs.existsSync localDir
    console.log "local dir[#{localDir}] is exist, delete first."
    exec "rm -rf #{localDir}", (err, stdout, stderr)->
        console.log err if err?
