$('#pub-form').ajaxForm {
    dataType: 'json',
    success: (data)->
        d = new Date()
        $msgline = $('.msgline')
        $pubLog = $('#pub-log')
        if data.data?
            for log in data.data
                $pubLog.append '<span class="line ' + log.type + '">' + log.msg + '</span>'
        $pubLog.append '<hr/>'
        if data.status == 1
            $msgline.html(data.msg).removeClass('text-error').addClass 'text-success'
        else
            $msgline.html(data.msg).removeClass('text-success').addClass 'text-error'
        $msgline.fadeIn 200, ->
            $msgline.fadeOut 3000
}