var Echo, debug, net;

debug = require('debug')('lazyparking-server');

net = require("net");

Echo = require("./services/echo");

module.exports = {
  setPort: function(port) {
    this.port = port;
  },
  getPort: function() {
    return this.port;
  },
  start: function(callback) {
    var server;
    server = net.createServer(function(client) {
      console.log("server connected");
      client.on("end", function() {
        return console.log("server disconnected");
      });
      return new Echo(client);
    });
    return server.listen(this.port, callback);
  }
};
