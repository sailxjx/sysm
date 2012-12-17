$('.sms-chzn-select').chosen {
    no_results_text: "No results matched"
}
$('#smsChannelForm').ajaxForm {
    dataType: 'json',
    method: 'post',
    success: (data)->
        msgShow data.msg, data.status
        if data.status == 1
            boardReload {
                board: 'smschannels'
            }
}
$('.sms-channel-delete').click ->
    c = confirm('Are you sure?')
    if c
        $('#scAction').val('del')
        $('#popback').click()
    else
        return false