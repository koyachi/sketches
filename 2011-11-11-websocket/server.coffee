#!/usr/bin/env coffee
#io = require('socket.io').listen 8080
#io.sockets.on 'connection', (socket) ->
#  socket.emit 'news', hello: 'world'
#  socket.on 'my other event', (data) ->
#    console.log data

fs = require 'fs'

handler = (req, res) ->
  console.log 'handler now!'
  fs.readFile __dirname + '/index.html', (err, data) ->
    if err
      console.log 'error'
      res.writeHead 500
      return res.end 'Error loading index.html'
    console.log 'ok'
    res.writeHead 200
    res.end data

app = require('http').createServer handler
io = require('socket.io').listen app
#http = require 'http'
#io = require('socket.io').listen http

app.listen 8080

#run = (httpHandler) ->
#  http.createServer httpHandler
#  http.listen 8080
##  io.listen http
#  console.log __dirname


io.sockets.on 'connection', (socket) ->
  socket.emit 'news',
    hello: 'world'
    r: 100
    g: 0
    b: 0
  socket.on 'my other event', (data) ->
    console.log data

#run handler
