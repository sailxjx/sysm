// Generated by CoffeeScript 1.4.0
(function() {
  var socket;

  socket = io.connect('http://127.0.0.1:3001');

  socket.on('news', function(data) {
    console.log(data);
    return socket.emit('myotherevent', {
      my: 'data'
    });
  });

}).call(this);