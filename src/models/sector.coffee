mongoose = require("mongoose")
Schema   = mongoose.Schema

SectorSchema = new Schema
  _id: {type: Number, required: true, unique: true}
  name: String
  boxes: [{type: Number, ref: 'Box'}] # population
  created: {type: Date, default: Date.now}

module.exports = mongoose.model 'Sector', SectorSchema