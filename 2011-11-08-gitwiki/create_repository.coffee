#!/usr/bin/env coffee
Gitteh = require 'gitteh'
Path = require 'path'
Fs = require 'fs'

createRepository = (repositoryName) ->
  destination = Path.join '/tmp', 'nottit_test__coffee__' + repositoryName
  console.log destination
  Fs.mkdirSync destination, '777'
  repo = Gitteh.initRepository destination
  repo

createRepository 'bar'
