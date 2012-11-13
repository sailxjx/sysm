exec = require('child_process').exec
spawn = require('child_process').spawn
fs = require 'fs'

pubData =
    prefix: '/tmp/pub/'
    username: 'hudson'
    password: 'JvjLYFIr'

pname = 'sysd'
project =
    vcs: 'git'
    url: 'git://github.com/51fanli/sysd.git'
    dir: '/usr/local/webdata/fun'

localDir = pubData.prefix + pname

rsync = ->
    switch project.vcs
        when 'git' then rsyncGit()
        when 'svn' then rsyncSvn()
        else console.log 'error: project.vcs not found'

rsyncGit = ->
    console.log "git clone #{project.url} #{localDir}"
    # exec "git clone #{project.url} #{localDir}", (err, stdout, stderr)->
    #     console.log stdout.toString()
    gitClone = spawn 'git', ['clone', project.url, localDir]
    gitClone.stdout.on 'data', (data)->
        console.log data.toString()

rsyncSvn = ->


if fs.existsSync localDir
    console.log "local dir[#{localDir}] is exist, delete first."
    exec "rm -rf #{localDir}", (err, stdout, stderr)->
        console.log err if err?
        rsync()
else
    rsync()