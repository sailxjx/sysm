$('#mailTempForm').ajaxForm {
    dataType: 'json',
    method: 'post'
    success: (data)->
        msgShow data.msg, data.status
        if data.status == 1
            boardReload {
                board: 'mailtemplates'
            }
}    

$('.mail-temp-edit').click ->
    for i of CKEDITOR.instances
        CKEDITOR.instances[i].updateElement()

$('.mail-temp-delete').click ->
    c = confirm('Are you sure?')
    if c
        $('#mailEditAction').val('del')
        $('#popback').click()
    else
        return false