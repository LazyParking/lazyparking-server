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

module.exports = mongoose.model 'Sector', SectorSchema
