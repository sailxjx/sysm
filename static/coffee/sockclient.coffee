socket = io.connect 'http://127.0.0.1:3001'
socket.on 'news', (data)->
    console.log data
    socket.emit 'myotherevent', {my:'data'}
