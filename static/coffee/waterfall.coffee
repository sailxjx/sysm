# tmp demo
class waterfall
    constructor: ()->
        @params =
            eleWidth: 580
            minColumn: 1
            container: $('#container')
            ele: $('.board')
            initHeight: 60
    reCompose: ()=>
        columns = parseInt @params.container.width() / @params.eleWidth
        heights = []
        conOffset = @params.container.offset()
        for i in [0..columns-1]
            heights.push @params.initHeight
        _params = @params
        _params.ele.each (i)->
            leftIndex = i % columns
            eleHeight = $(this).height() + 8
            $(this).css {
                position: 'absolute'
                top: heights[leftIndex] + 'px'
                left: (conOffset.left + _params.eleWidth * leftIndex) + 'px'
            }
            heights[leftIndex] = heights[leftIndex] + eleHeight

oWF = new waterfall()
to = null
$(window).load ()->
    setTimeout (->
        oWF.reCompose()
        ),100
$(window).resize ()->
    clearTimeout to
    to = setTimeout (->
        oWF.reCompose()), 500

