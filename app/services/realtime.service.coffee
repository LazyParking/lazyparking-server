io       = require("socket.io")
ObjectId = require("mongoose").Types.ObjectId

Box      = require("../models/box")
Sector   = require("../models/sector")

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
  # Emmited events (with arguments sent) are:
  # * box register, box
  #   creates a new box
  # * box update, box
  #   sets the occupied status of a box
  # * sector count, {"_id", "available", "status" }
  #   count the available boxes on sector

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
    @sectorCount box.sector

  boxUpdate: (box) ->
    @io.emit 'box update', box
    @sectorCount box.sector

  sectorCount: (sector_id) ->
    return unless sector_id?
    # find the sector
    Sector.findOne(_id: new ObjectId sector_id).populate('boxes')
      .exec (err, sector) =>
        return console.error err if err
        return unless sector? # not found
        # emit event with count data
        @io.emit 'sector count',
          _id      : String(sector._id)
          available: sector.getAvailable().length
          status   : sector.getStatus()

# returns an instance (and not the class)
module.exports = new Realtime
