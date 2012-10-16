loadBoards = ()->
    $('.board').each ()->
        bd = $(this).attr 'board'
        if bd
            $(this).load getBoardUrl $(this).attr 'board'
        $(this).mouseenter ()->
            $(this).addClass('board-hover')
        $(this).mouseleave ()->
            $(this).removeClass('board-hover')

getBoardUrl = (name)->
    "http://sysm.local.com/board/#{name}"

loadBoards()
# replaceBoards()