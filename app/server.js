var Echo, config, net, server;

net = require('net');

config = require('./config/config');

Echo = require('./controllers/echo');

server = net.createServer(function(client) {
  console.log("server connected");
  client.on('end', function() {
    return console.log("server disconnected");
  });
  return new Echo(client);
});

server.listen(config.serverPort, function() {
  console.log("server started");
  return console.log("server listening on port " + config.serverPort);
});
