mongoose = require("mongoose")
Schema   = mongoose.Schema

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

module.exports = mongoose.model 'Sector', SectorSchema
