mongoose = require("mongoose")
Schema   = mongoose.Schema

BoxSchema = new Schema
  id          : {type: Number, required: true}
  droneId     : {type: Number, required: true}
  droneAddress: {type: String, required: true}
  occupied    : {type: Boolean, default: false}
  created     : {type: Date, default: Date.now}

BoxSchema.index { id: true, droneId: true }, { unique: true }

module.exports = mongoose.model 'Box', BoxSchema