exec = require('child_process').exec
spawn = require('child_process').spawn
colors = require 'colors'
fs = require 'fs'
db = require "#{APP_PATH}/lib/db"
rc = db.loadRedis('redisPub')

module.exports = 
spub = (params, callback)->
    pubData =
        prefix: '/tmp/pub/'
        username: 'hudson'
        password: 'JvjLYFIr'
    project = localDir = destDir = target = null
    pubInit = ->
        if !params.pname || !params.target
            eback 'pname* or target* not found'
        rc.hget 'publish:targets', params.target, (err, reply)->
            if err? then eback err else
                if !reply then eback 'target not found' else
                    target = JSON.parse reply
                    rc.hget 'publish:projects', params.pname, (err, reply)->
                        if err? then eback err else
                            if !reply then eback 'project not found' else
                                project = JSON.parse reply
                                localDir = pubData.prefix + project.pname
                                destDir = project.dir
                                checkDestDir()

    checkDestDir = ->
        glog "check destination dir: #{destDir}"
        if fs.existsSync destDir
            checkLocalDir()
        else
            glog "destination dir[#{destDir}] is not exist, create it."
            exec "mkdir -p #{destDir}", (err, stdout, stderr)->
                if err?
                    eback err
                else
                    slog 'dir created'
                    checkLocalDir()

    checkLocalDir = ->
        glog "check local dir: #{localDir}"
        if fs.existsSync localDir
            glog "local dir[#{localDir}] is exist, delete first."
            exec "rm -rf #{localDir}", (err, stdout, stderr)->
                if err?
                    eback err
                else
                    slog 'delete succ'
                    rsync()
        else
            rsync()

    glog = (msg)->
        console.log msg.toString().grey

    elog = (msg)->
        console.log msg.toString().red

    slog = (msg)->
        console.log msg.toString().green

    eback = (err, data = null)->
        elog err
        callback err, data

    sback = (data)->
        callback null, data

    rsync = ->
        switch project.vcs
            when 'git' then rsyncGit()
            when 'svn' then rsyncSvn()
            else eback 'error: project.vcs not found'

    rsyncGit = ->
        stepIn = ->
            if fs.existsSync localDir
                stepArch()
            else
                exec "mkdir -p #{localDir}", (err, stdout, stderr)->
                    if err?
                        eback 'could not make local dir'
                    else
                        stepArch()
            # git archive master --remote=git@192.168.100.54:sysd.git --format=tar --prefix=sysd/ | tar -xf - -C /tmp/pub
        stepArch = ->
            cmd = ['git', 'archive']
            cmd.push getBranch()
            cmd.push "--remote=#{project.url}"
            cmd.push "--format=tar | tar -xf - -C #{localDir}"
            cmdStr = cmd.join ' '
            glog "archive git repositories: #{cmdStr}"
            exec cmdStr, (err, stdout, stderr)->
                if err?
                    eback err
                else
                    slog 'archive succ'
                    stepRsync()
        stepRsync = ->
            cmd = ['rsync', '-aq', '--delete-after', '--ignore-errors', '--force']
            cmd = cmd.concat getExclude()
            cmd = cmd.concat [localDir, project.dir]
            cmdStr = cmd.join ' '
            glog "rsync to destination: #{cmdStr}"
            exec cmdStr, (err, stdout, stderr)->
                if err? then eback err else
                    slog 'rsync succ'
                    sback stdout
        getExclude = ->
            []
        getBranch = ->
            branch = null
            if params.branch?
                branch = params.branch
            else if target.gbr
                branch = target.gbr
            else
                branch = 'product'
            branch
        stepIn()

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
            glog "export svn repositories: #{cmdStr}"
            exec cmdStr, (err, stdout, stderr)->
                if err?
                    eback err
                else
                    slog 'export succ'
                    stepRsync()
        stepRsync = ->
            cmd = ['rsync', '-aq', '--delete-after', '--ignore-errors', '--force']
            cmd = cmd.concat getExclude()
            cmd = cmd.concat [localDir, project.dir]
            cmdStr = cmd.join ' '
            glog "rsync to destination: #{cmdStr}"
            exec cmdStr, (err, stdout, stderr)->
                if err? then eback err else 
                    slog 'rsync succ'
                    sback stdout
        getExclude = ->
            ['--exclude=Conf/', '--exclude=.svn/']
        getUrl = ->
            if params.branch?
                url = project.url + '/branches/' + params.branch
            else if target.sbr
                url = "#{project.url}/#{target.sbr}/"
            else
                url = "#{project.url}/release/"
            url
        stepIn()

    pubInit()