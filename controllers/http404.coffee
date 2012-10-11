controller = require './controller'

module.exports = 
class http404 extends controller
    render: () ->
        this.data.title = 'Welcome to 404'
        this.res.render 'http404', this.data
