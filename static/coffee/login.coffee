$('#login-form').ajaxForm {
    dataType: 'json',
    success: (data)->
        console.log data
}