mongoose = require("mongoose")
Schema   = mongoose.Schema

Box = require("./box")
BoxSchema = Box.schema

SectorSchema = new Schema
  sectorId: {type: Number, required: true, unique: true}
  name: String
  orphan: {type: Boolean, default: false}
  boxes: [BoxSchema]
  created: {type: Date, default: Date.now}

module.exports = mongoose.model 'Sector', SectorSchema