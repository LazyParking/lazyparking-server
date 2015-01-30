io = require('socket.io')

###
singleton class
Sends messages to browser in realtime
by using socket IO
###
class Realtime
  # @private, @static
  _instance = null

  # Socket.IO client
  # @private
  # @type io
  #
  # Emmited events are:
  # * box register
  #   creates a new box
  # * box update
  #   sets the occupied status of a box  io: null

  # constructor returns singleton instance,
  # if exists, or new instance
  constructor: ->
    if _instance?
      return _instance
    _instance = @

  # set Socket.io instance
  setSocketIo: (@io) ->

  boxRegister: (box) ->
    @io.emit 'box register', box

  boxUpdate: (box) ->
    @io.emit 'box update', box

# returns an instance (and not the class)
module.exports = new Realtime
