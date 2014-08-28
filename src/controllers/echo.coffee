# Class for just echoing messages
class Echo
  # the tcp client
  client: null

  constructor: (@client) ->
    @client.write "Hello!\r\n"
    @client.pipe @client

# export me
module.exports = Echo