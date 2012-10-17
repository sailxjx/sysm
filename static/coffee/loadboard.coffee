loadBoards = ()->
    $('.board').each ()->
        bd = $(this).attr 'board'
        if bd
            bUrl = getBoardUrl $(this).attr 'board'
            $(this).load bUrl
            if !$(this).attr 'target-url'
                $(this).attr 'target-url', bUrl
        $(this).click ()->
            if tUrl = $(this).attr 'target-url'
                popen tUrl
        $(this).mouseenter ()->
            $(this).addClass 'board-hover'
        $(this).mouseleave ()->
            $(this).removeClass 'board-hover'
getBoardUrl = (name)->
    "http://sysm.local.com/board/#{name}"

popen = (url)->
    $('#popback').show()
    $('#popen').load url, ()->
        $(this).fadeIn 100, ()->
            $(this).css {
                'width': '80%',
                'margin-left': '-40%'
            }

$('#popback').click ()->
    $('#popen').css({
        'width': '0',
        'margin-left': '0'
    }).fadeOut 500, ()->
        $('#popback').hide()

$('#popen').click (e)->
    e.stopPropagation() # stop popback fadeOut

loadBoards()
