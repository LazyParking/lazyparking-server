debug  = require('debug')('lazyparking-server')
net    = require("net")

Drone   = require("./services/drone.service")

module.exports =
  setPort: (@port) ->

  getPort: ->
    @port

  start: (callback) ->
    server = net.createServer (client) ->
      debug "server connected", client.remoteAddress
      
      client.on "end", ->
        debug "server disconnected"

      new Drone(client)

    server.listen @port, callback