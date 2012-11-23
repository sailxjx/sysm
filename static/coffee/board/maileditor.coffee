$('#mailTempFrom').ajaxForm {
    dataType: 'json',
    method: 'post'
    success: (data)->
        $msgline = $('.msgline')
        if data.status == 1
            $msgline.html(data.msg).removeClass('text-error').addClass 'text-success'
            boardReload {
                board: 'mailtemplates'
            }
        else
            $msgline.html(data.msg).removeClass('text-success').addClass 'text-error'
        $msgline.fadeIn 200, ->
            $msgline.fadeOut 3000
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