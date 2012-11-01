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
    "/board/#{name}"

popen = (url)->
    $('#popback').show()
    $('#popen').fadeIn 100, ()->
        $(this).animate {
            'width': '80%',
            'margin-left': '-40%'
        }, 300, ()->
            $(this).load url
            
bindPopen = ()->
    $('.bp').click ()->
        if tUrl = $(this).attr 'target-url'
            popen tUrl
    $('#popback').click ()->
        $('#popen').children('.bcon').fadeOut()
        $('#popen').css({
            'width': '0',
            'margin-left': '0'
        }).fadeOut 500, ()->
            $('#popback').hide()
    $('#popen').click (e)->
        e.stopPropagation() # stop popback fadeOut


loadBoards()
bindPopen()
