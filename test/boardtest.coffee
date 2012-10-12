bc = {}
class bc.configs
    echo: ->
        'hello'

board = 'config'

if bc[board]
    console.log bc
else
    console.log 'error'