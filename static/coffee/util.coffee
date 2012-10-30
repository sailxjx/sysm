$('#popback').click ()->
    $('#popen').css({
        'width': '0',
        'margin-left': '0'
    }).fadeOut 500, ()->
        $('#popback').hide()

$('#popen').click (e)->
    e.stopPropagation() # stop popback fadeOut

popen = (url)->
    $('#popback').show()
    $('#popen').load url, ()->
        $(this).fadeIn 100, ()->
            $(this).css {
                'width': '80%',
                'margin-left': '-40%'
            }

bindPopen = ()->
    $('.bp').click ()->
        if tUrl = $(this).attr 'target-url'
            popen tUrl

bindPopen()