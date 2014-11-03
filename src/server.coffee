debug  = require('debug')('lazyparking-server')
net    = require("net")

Drone   = require("./services/drone.service")

module.exports =
  setPort: (@port) ->

  getPort: ->
    @port

  start: (callback) ->
    server = net.createServer (client) ->
      console.log "server connected", client.address()
      
      client.on "end", ->
        console.log "server disconnected"

      new Drone(client)

    server.listen @port, callback