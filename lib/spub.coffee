exec = require('child_process').exec
spawn = require('child_process').spawn
colors = require 'colors'
fs = require 'fs'

pubData =
    prefix: '/tmp/pub/'
    username: 'hudson'
    password: 'JvjLYFIr'

params =
    version: null
    branch: 'goshopv3'

# pname = 'sysd'
# project =
#     vcs: 'git'
#     url: 'git@192.168.100.54:sysd.git'
#     dir: '/usr/local/www/sysd'

pname = 'fun'
project =
    vcs: 'svn'
    url: 'svn://192.168.0.178/fun/'
    dir: '/usr/local/webdata/fun'

localDir = pubData.prefix + pname
destDir = project.dir

clog = (msg)->
    console.log msg.blue

# @todo fix color bug
elog = (msg)->
    console.log msg

rsync = ->
    switch project.vcs
        when 'git' then rsyncGit()
        when 'svn' then rsyncSvn()
        else elog 'error: project.vcs not found'

rsyncGit = ->
    clog "git clone #{project.url} #{localDir}"
    exec "git clone #{project.url} #{localDir}", (err, stdout, stderr)->
        clog stdout.toString()
    gitClone = spawn 'git', ['clone', project.url, localDir]
    gitClone.stdout.on 'data', (data)->
        clog data.toString()

rsyncSvn = ->
    stepIn = ->
        stepExport()

    stepExport = ->
        cmd = ['svn','export', '-q']
        cmd = cmd.concat ['-r', params.version] if params.version?
        cmd.push getUrl()
        cmd.push localDir
        cmd = cmd.concat ['--username', pubData.username, '--password', pubData.password]
        cmdStr = cmd.join ' '
        clog "checkout svn repositories: \n#{cmdStr}"
        exec cmdStr, (err, stdout, stderr)->
            elog err if err?
            stepRsync()

    stepRsync = ->
        cmd = ['rsync', '-aq', '--delete-after', '--ignore-errors', '--force']
        cmd = cmd.concat getExclude()
        cmd = cmd.concat [localDir, project.dir]
        cmdStr = cmd.join ' '
        clog "rsync to destination: \n#{cmdStr}"
        exec cmdStr, (err, stdout, stderr)->
            elog err if err?

    getExclude = ->
        ['--exclude=Conf/', '--exclude=.svn/']

    getUrl = ->
        if params.branch?
            url = project.url + 'branches/' + params.branch
        else
            switch params.target
                when 'alpha1','alpha2' then url = project.url + 'trunk/'
                else url = project.url + 'release/'
        url

    if fs.existsSync localDir
        clog "local dir[#{localDir}] is exist, delete first."
        exec "rm -rf #{localDir}", (err, stdout, stderr)->
            elog err if err?
            stepIn()
    else
        stepIn()

clog "check destination dir: #{destDir}"
if fs.existsSync destDir
    rsync()
else
    clog "destination dir[#{destDir}] is not exist, create it."
    exec "mkdir -p #{destDir}", (err, stdout, stderr)->
        if err?
            elog err
        else
            rsync()