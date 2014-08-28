var Echo;

Echo = (function() {
  Echo.prototype.client = null;

  function Echo(client) {
    this.client = client;
    this.client.write("Hello!\r\n");
    this.client.pipe(this.client);
  }

  return Echo;

})();

module.exports = Echo;
