# page to generate short url
controller = require "lib/controllers/controller"
db = require "lib/db"

module.exports = 
class url extends controller
    render: () ->
        surl = this.req.params.surl
        if !surl
            # render the url shorter page
            @res.render 'url', @res.data
        else
            # redirect to correct url
            @res.send 'error'
