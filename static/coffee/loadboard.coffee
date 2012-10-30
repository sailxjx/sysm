loadBoards = ()->
    $('.board').each ()->
        bd = $(this).attr 'board'
        if bd
            bUrl = getBoardUrl $(this).attr 'board'
            $(this).load bUrl
            if !$(this).attr 'target-url'
                $(this).attr 'target-url', bUrl
        $(this).mouseenter ()->
            if $(this).hasClass 'bp'
                $(this).addClass 'board-hover'
        $(this).mouseleave ()->
            $(this).removeClass 'board-hover'
getBoardUrl = (name)->
    "http://sysm.local.com/board/#{name}"

loadBoards()
