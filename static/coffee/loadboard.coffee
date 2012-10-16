loadBoards = ()->
    $('.board').each ()->
        bd = $(this).attr 'board'
        if bd
            $(this).load getBoardUrl $(this).attr 'board'

getBoardUrl = (name)->
    "http://sysm.local.com/board/#{name}"

replaceBoards = ()->
    # wh = $(window).height()
    # ww = $(window).width()
    ww = 1905
    wh = 700
    bPerLine = parseInt ww/300
    regSize = /board\-([a-zA-Z]+)(\s)?/i
    obSize = 
        large: '4*4'
        medium: '2*2'
        small: '1*1'
    blocks = [1..100]
    $('.board').each ()->
        bSize = regSize.exec($(this).attr('class'))[1]
        if obSize[bSize]
            return true
        false

# loadBoards()
replaceBoards()