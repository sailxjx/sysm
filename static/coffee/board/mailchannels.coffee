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
    d = new Date()
    t = d.getTime()
    $.ajax {
        url: '/api/mailchanneledit?t='+t,
        data: mailChannels,
        dataType: 'json',
        method: 'get',
        success: (data)->
            msgShow data.msg, data.status
            if data.status == 1
                boardReload {
                    board: 'mailchannels'
                }
    }
