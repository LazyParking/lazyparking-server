mongoose = require("mongoose")
Schema   = mongoose.Schema

BoxSchema = new Schema
  id          : {type: Number, required: true}
  droneId     : {type: Number, required: true}
  droneAddress: {type: String, required: true}
  occupied    : {type: Boolean, default: false}
  created     : {type: Date, default: Date.now}
  updated     : {type: Date, default: Date.now}

# set an index for uniq box and drone ids
BoxSchema.index { id: true, droneId: true }, { unique: true }
# update the update date
BoxSchema.pre 'save', (next) ->
  this.updated = new Date()
  next()

module.exports = mongoose.model 'Box', BoxSchema