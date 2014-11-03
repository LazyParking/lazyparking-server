var Drone, debug, net;

debug = require('debug')('lazyparking-server');

net = require("net");

Drone = require("./services/drone.service");

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
      console.log("server connected", client.address());
      client.on("end", function() {
        return console.log("server disconnected");
      });
      return new Drone(client);
    });
    return server.listen(this.port, callback);
  }
};
