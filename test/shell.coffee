child_process = require 'child_process'
spawn = child_process.spawn
exec = child_process.exec

# console.log spawn
exec 'svn list svn://192.168.0.178/fun', (err, stdout, stderr)->
    console.log stdout