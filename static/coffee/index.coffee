getBoardUrl = (name)->
    "/board/#{name}"

popen = (url)->
    $('#popback').show()
    $('#popen').fadeIn 100, ()->
        $(this).animate {
            'width': '80%',
            'margin-left': '-40%'
        }, 300, ()->
            $(this).load url

# bind events on boards
$('.board').each ()->
    bd = $(this).attr 'board'
    if bd
        bUrl = getBoardUrl $(this).attr 'board'
        $(this).load bUrl
        if !$(this).attr 'target-url'
            $(this).attr 'target-url', bUrl
    $(this).mouseenter ()->
        if $(this).hasClass 'bp'
            $(this).addClass 'board-hover'
    $(this).mouseleave ()->
        $(this).removeClass 'board-hover'

# bind events on bp
$('.bp').click ()->
    if tUrl = $(this).attr 'target-url'
        popen tUrl

# bind events on
# popback
# addJob
$(document).on('click','#popback', (e)->
    if e.target.id == 'popback'
        $('#popen').children('.bcon').fadeOut()
        $('#popen').css({
            'width': '0',
            'margin-left': '0'
        }).fadeOut 500, ()->
            $('#popback').hide()
).on('click', '#cmdAdd', (e)->
    cmd = $.trim($('#cmdInput').val());
    if cmd == ''
        return false
    $.ajax {
        url: '/api/startjob'
        data: {
            cmd: cmd
        }
        type: 'get'
        dataType: 'json'
        success: (d)->
            if d.status == 1
                $('#cmdInput').parent().parent().removeClass('error').addClass('success')
            else
                $('#cmdInput').parent().parent().removeClass('success').addClass('error')
    }
).on('keydown', '#cmdInput', (e)->
    if e.which == 13
        $('#cmdAdd').trigger 'click'
)