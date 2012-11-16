global.APP_PATH = __dirname + '/..'
spub = require '../lib/spub'

params =
    pname: 'fun'
    version: null
    branch: 'goshop'
    target: 'alpha1',
    timestamp: false

cback = (err, data)->
    if err?
        console.log 'error' 
    else 
        console.log 'succ'

spub(params, cback)