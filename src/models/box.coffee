mongoose = require("mongoose")
Schema   = mongoose.Schema

BoxSchema = new Schema
  _id: {type: Number, required: true}
  avaiable: {type: Boolean, default: false}
  droneId: {type: Number, required: true}   # Maybe should be another schema
  created: {type: Date, default: Date.now}

module.exports = mongoose.model 'Box', BoxSchema