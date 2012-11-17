interceptor = require 'lib/interceptors/interceptor'

module.exports = 
class auth extends interceptor
    before: ->
        