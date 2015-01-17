mongoose = require("mongoose")
Schema   = mongoose.Schema

Box      = require("./box")

SectorSchema = new Schema
  name       : String
  description: String
  gate       : String
  boxes      : [{type: Schema.Types.ObjectId, ref: 'Box'}] # population
  created    : {type: Date, default: Date.now}
  updated    : {type: Date, default: Date.now}

# update the update date
SectorSchema.pre 'save', (next) ->
  this.updated = new Date()
  next()

SectorSchema.post 'save', (sector) ->
  sector.boxes.forEach (box_id) ->
    Box.update _id: box_id,
      sector: sector._id
    .exec()

SectorSchema.methods.addBox = (box_id, callback) ->
  this.update { $push: { boxes: box_id} }, callback

SectorSchema.methods.removeBox = (box_id, callback) ->
  this.update { $pull: { boxes: box_id} }, callback

module.exports = mongoose.model 'Sector', SectorSchema
