debug  = require('debug')('lazyparking-server')
net    = require("net")

Echo   = require("./services/echo")

module.exports =
  setPort: (@port) ->

  getPort: ->
    @port

  start: (callback) ->
    server = net.createServer (client) ->
      console.log "server connected"
      
      client.on "end", ->
        console.log "server disconnected"

      new Echo(client)

    server.listen @port, callback