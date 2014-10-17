var Echo, net;

net = require("net");

Echo = require("./services/echo");

exports.start = function() {
  var server;
  server = net.createServer(function(client) {
    console.log("server connected");
    client.on("end", function() {
      return console.log("server disconnected");
    });
    return new Echo(client);
  });
  return server.listen(process.env.SERV_PORT || 3030, function() {
    console.log("server started");
    return console.log("server listening on port " + (process.env.SERV_PORT || 3030));
  });
};
