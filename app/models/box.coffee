mongoose = require("mongoose")
Schema   = mongoose.Schema

BoxSchema = new Schema
  _id: {type: Number, required: true}
  avaiable: {type: Boolean, default: false}
  drone: {
    id: {type: Number, required: true}
    address: {type: String, required: true}
  }
  created: {type: Date, default: Date.now}

module.exports = mongoose.model 'Box', BoxSchema