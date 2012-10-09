exports.index = (req, res) ->
    res.render 'index', {
        title: 'System backyard',
        dconfs: ["one", "two", "three"]
    }

exports.http404 = (req, res) ->
    res.send '404'

exports.board = (req, res) ->
    console.log req.params
    res.send 'succ'