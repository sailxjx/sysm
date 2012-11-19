controller = require 'lib/controllers/controller'

module.exports = 
class http404 extends controller
    render: () =>
        @data.title = 'Welcome to 404'
        @res.statusCode = 404
        @res.render 'http404', @data
    before: () =>
        @render()
