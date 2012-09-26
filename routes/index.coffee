exports.index = (req, res) ->
    res.render 'index', {
        title: 'sysm',
        content: 'welcome to system management'
    }

