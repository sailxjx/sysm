$('#pub-form').ajaxForm {
    dataType: 'json',
    success: (data)->
        d = new Date()
        $pubLog = $('#pub-log')
        if data.data?
            for log in data.data
                $pubLog.append '<span class="line ' + log.type + '">' + log.msg + '</span>'
        $pubLog.append '<hr/>'
        msgShow data.msg, data.status
}