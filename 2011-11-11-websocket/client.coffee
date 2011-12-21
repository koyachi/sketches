$ ->
  console.log 'ready'

socket = io.connect 'http://localhost:8080'
socket.on 'news', (data) ->
  console.log data
  $('#contents').css('background', ['rgb(', data.r, ', ', data.g, ', ', data.b, ')'].join(''))
  console.log($('#contents').css('background'))
  socket.emit 'my other event', my: 'data'
