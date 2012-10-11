controller = require './controller'

module.exports = 
class index extends controller
    render: () ->
        this.res.render 'index', this.data
