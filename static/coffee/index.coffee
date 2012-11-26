root = exports ? this
# bind events on boards
root.boardReload = (attrs = {})->
    $('.board').each ->
        $this= $(this)
        reloadFlag = true
        for i of attrs
            if $this.attr(i) != attrs[i]
                reloadFlag = false
        if reloadFlag
            bUrl = getBoardUrl $this.attr 'board'
            $this.load bUrl

boardHover = ->
    $('.board').each ->
        $this = $(this)
        $this.mouseenter ->
            $this.addClass 'board-hover'
        $this.mouseleave ->
            $this.removeClass 'board-hover'

getBoardUrl = (name)->
    "/board/#{name}"

popen = (url, callback)->
    $('#popback').show()
    $('#popen').fadeIn 100, ()->
        $(this).animate {
            'width': '90%',
            'margin-left': '-45%'
        }, 300, ()->
            $(this).load url, ()->
                if callback?
                    callback()

boardReload()
boardHover()

ckMailEditor = null;
targetCallback =
    mailtempedit: ()->
        if ckMailEditor?
            ckMailEditor.destroy true
            ckMailEditor = null
        ckMailEditor = CKEDITOR.replace 'maileditor', { "height": 500 }

$(".chzn-select").chosen {
    no_results_text: "No results matched"
}

# bind events on
# boardpopen
# popback
# addJob
$(document).on('click', '.boardpopen', (e)->
    if tUrl = $(this).attr 'target-url'
        [callbackName, tmpParams] = tUrl.split('/').pop().split('?')
        if targetCallback[callbackName]? && typeof targetCallback[callbackName] != "undefined"
            popen tUrl, targetCallback[callbackName]
        else
            popen tUrl
).on('click','#popback', (e)->
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

$(window).load ()->
    setTimeout (->
        $('#container').masonry {
            itemSelector: '.board'
        }), 200