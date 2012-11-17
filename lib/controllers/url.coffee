# page to generate short url
controller = require "lib/controllers/controller"
db = require "lib/db"

module.exports = 
class url extends controller
    render: () ->
        surl = this.req.params.surl
        if !surl
            # render the url shorter page
            this.res.render 'url', this.data
        else
            # redirect to correct url
            this.res.send 'error'
