controller = require 'lib/controllers/controller'

module.exports = 
class http404 extends controller
    render: () =>
        @res.data.title = 'Welcome to 404'
        @res.statusCode = 404
        @res.render 'http404', @res.data
    before: () =>
        @render()
