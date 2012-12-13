$('#smsTempForm').ajaxForm {
    dataType: 'json',
    method: 'post',
    success: (data)->
        msgShow data.msg, data.status
        if data.status == 1
            boardReload {
                board: 'smstemplates'
            }
}
$('.sms-temp-delete').click ->
    c = confirm('Are you sure?')
    if c
        $('#smsEditAction').val('del')
        $('#popback').click()
    else
        return false