# global functions
this.msgShow = (msg, status)->
    $msgBlock = $('.msg-block')
    $msgBlock.css {
        'padding': '15px 0'
        'height': '20px'
        'display': 'block'
    }
    $msgLine = $msgBlock.find('.msg-line')
    $msgLine.show()
    $msgLine.html(msg)
    if status == 1
        $msgBlock.removeClass('text-error').addClass('text-success')
    else
        $msgBlock.removeClass('text-success').addClass('text-error')
    w = $msgLine.width()
    ww = $(window).width()
    $msgLine.css {
        'margin-left': (ww - w)/ 2 + 'px'
    }
    setTimeout (->
        $msgBlock.css {
            'padding': 0
            'height': 0
        }
        $msgLine.html('').css {
            'margin-left': 0
        }
        ), 3000