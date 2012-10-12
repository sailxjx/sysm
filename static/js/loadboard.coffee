loadBoard = ()->
    $('.board').each ()->
        bd = $(this).attr 'board'
        if bd
            $(this).load getBoardUrl $(this).attr 'board'

getBoardUrl = (name)->
    "http://sysm.local.com/board/#{name}"

loadBoard()
