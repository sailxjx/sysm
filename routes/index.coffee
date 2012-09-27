exports.index = (req, res) ->
    res.render 'index', {
        title: 'System backyard',
        dconfs: ["one", "two", "three"]
    }