io = require('socket.io')

# singleton class
# Sends messages to browser in realtime
# by using socket IO
class Realtime
  # @private, @static
  _instance = null

  # @type SocketIo
  io: null

  # constructor returns singleton instance,
  # if exists, or new instance
  constructor: ->
    if _instance?
      # check if instance has socket io
      unless _instance.io instanceof io
        throw new Error("Socket.io instance not found.")
      # returns previous instance
      return _instance
    _instance = @

  # set Socket.io instance
  setSocketIo: (@io) ->

module.exports = Realtime
