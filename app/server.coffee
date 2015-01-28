debug  = require('debug')('lazyparking-server')
net    = require("net")

Drone   = require("./services/drone.service")

module.exports =
  setPort: (@port) ->

  getPort: ->
    @port

  setSocketIo: (@io) ->

  start: (callback) ->
    server = net.createServer (client) =>
      debug "server connected", client.remoteAddress

      client.on "end", ->
        debug "server disconnected"

      new Drone(client, @io)

    server.listen @port, callback
