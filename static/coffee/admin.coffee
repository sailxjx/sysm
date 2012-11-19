$('#reg-form').ajaxForm {
    dataType: 'json',
    success: (data)->
        $subTip = $('#subTip')
        if data.status == 1
            $subTip.removeClass('err').addClass('succ')
        else
            $subTip.removeClass('succ').addClass('err')
        $subTip.html data.msg
}