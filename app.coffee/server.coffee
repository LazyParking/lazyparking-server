net    = require("net")

Echo   = require("./services/echo")

exports.start = ->
  server = net.createServer (client) ->
    console.log "server connected"
    
    client.on "end", ->
      console.log "server disconnected"

    new Echo(client)

  server.listen process.env.SERV_PORT || 3030, ->
    console.log "server started"
    console.log "server listening on port #{process.env.SERV_PORT || 3030}"