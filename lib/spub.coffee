exec = require('child_process').exec
spawn = require('child_process').spawn
colors = require 'colors'
fs = require 'fs'
func = require "lib/func"
db = require "lib/db"
rc = db.loadRedis('redisPub')

exports.spub = (params, callback)->
    pubData =
        prefix: '/tmp/pub/'
        username: 'hudson'
        password: 'JvjLYFIr'
        sshUser: 'tuangouadmin'
    project = localDir = destDir = target = null
    d = new Date()
    pubLog = [{
        type: 'log'
        msg: "publish time: #{d}"
    }]
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

    preHook = ->
        
    postHook = ->
        
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
                    publish()
        else
            publish()

    glog = (msg)->
        msg = msg.toString()
        pubLog.push {
            type: 'log'
            msg: msg
        }
        console.log msg.grey

    elog = (msg)->
        msg = msg.toString()
        pubLog.push {
            type: 'err'
            msg: msg
        }
        console.log msg.red

    slog = (msg)->
        msg = msg.toString()
        pubLog.push {
            type: 'succ'
            msg: msg
        }
        console.log msg.green

    eback = (err, data = null)->
        elog err
        logRedis()
        back err, pubLog

    sback = (data)->
        logRedis()
        back null, pubLog

    back = (err, data)->
        postHook()
        callback err, data

    logRedis = ()->
        rc.zadd 'publish:log', parseInt(d.getTime()/1000), JSON.stringify pubLog

    publish = ->
        preHook()
        switch project.vcs
            when 'git' then toGit()
            when 'svn' then toSvn()
            else eback 'error: project.vcs not found'

    toRsync = ->
        totalNum = succNum = 0
        stepIn = ->
            cmdList = []
            ssh = target.ssh
            for server of ssh
                [user, host] = server.split '@' # server could be '192.168.0.1' or 'tuangou@192.168.0.1'
                if func.empty host
                    host = user
                    user = pubData.sshUser
                for port in ssh[server]
                    cmd = ['rsync', '-aq', '--delete-after', '--ignore-errors', '--force']
                    cmd = cmd.concat ['-e', "\"ssh -p #{port}\""]
                    cmd = cmd.concat getExclude()
                    cmd = cmd.concat [localDir, "#{user}@#{host}:#{project.dir}"]
                    cmdList.push cmd.join ' '
            totalNum = cmdList.length
            for cmdStr in cmdList
                glog "rsync to destination: #{cmdStr}"
                exec cmdStr, (err, stdout, stderr)->
                    if err? then eback err else
                        slog "rsync succ: #{cmdStr}"
                        stepBack()
        stepBack = ->
            ++succNum
            if succNum < totalNum
                glog "#{succNum} server rsync succ."
                return true
            sback()
        getExclude = ->
            ['--exclude=Conf/', '--exclude=.svn/']
        stepIn()

    toGit = ->
        stepIn = ->
            if fs.existsSync localDir
                stepArch()
            else
                exec "mkdir -p #{localDir}", (err, stdout, stderr)->
                    if err?
                        eback 'could not make local dir'
                    else
                        stepArch()
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
                    toRsync()
        getBranch = ->
            branch = params.branch.trim()
            if branch? && branch != ''
                
            else if target.gbr
                branch = target.gbr
            else
                branch = 'product'
            branch
        stepIn()

    toSvn = ->
        stepIn = ->
            stepExport()
        stepExport = ->
            cmd = ['svn','export', '-q']
            version = params.version.trim()
            cmd = cmd.concat ['-r', version] if version? && version != ''
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
                    toRsync()
        getUrl = ->
            branch = params.branch.trim()
            if !func.empty branch
                url = project.url + '/branches/' + branch
            else if target.sbr
                url = "#{project.url}/#{target.sbr}/"
            else
                url = "#{project.url}/release/"
            url
        stepIn()

    pubInit()