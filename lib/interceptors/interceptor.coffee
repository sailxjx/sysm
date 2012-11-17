module.exports =
class interceptor
    constructor: (req, res)->
        @req = req
        @res = res
    before: ->
        true
    after: ->
        true