debug  = require('debug')('lazyparking-server')
net    = require("net")

Drone   = require("./services/drone.service")

# create a net server
server = net.createServer (client) ->
  debug "server connected", client.remoteAddress

  client.on "end", ->
    debug "server disconnected"

  # attach drone on each connection
  new Drone(client)

module.exports = server
