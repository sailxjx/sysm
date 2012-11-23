$('.mail-channel-temp').chosen()
$('.mc-ctrl').click (e)->
    $tr = $(this).parent().parent().parent()
    mailChannels = {}
    if $(this).hasClass('mc-delete')
        c = confirm('Are you sure?')
        if !c
            return false
        mailChannels.action = 'del'
    $tr.find('.data').each ->
        formName = $(this).attr('name')
        if formName != null && typeof formName != "undefined"
            mailChannels[formName] = $(this).val()
    $.ajax {
        url: '/api/mailchanneledit',
        data: mailChannels,
        dataType: 'json',
        method: 'get',
        success: (data)->
            $msgline = $('.msgline')
            if data.status == 1
                $msgline.html(data.msg).removeClass('text-error').addClass 'text-success'
                boardReload {
                    board: 'mailchannels'
                }
            else
                $msgline.html(data.msg).removeClass('text-success').addClass 'text-error'
            $msgline.fadeIn 200, ->
                $msgline.fadeOut 3000
    }
