net    = require('net')

config = require('./config/config')
Echo   = require('./controllers/echo')

server = net.createServer (client) ->
  console.log "server connected"
  
  client.on 'end', ->
    console.log "server disconnected"

  new Echo(client)

server.listen config.serverPort, ->
  console.log "server start"