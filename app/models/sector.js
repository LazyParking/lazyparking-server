var Box, BoxSchema, Schema, SectorSchema, mongoose;

mongoose = require("mongoose");

Schema = mongoose.Schema;

Box = require('./box');

BoxSchema = Box.schema;

SectorSchema = new Schema({
  id: Number,
  name: String,
  boxes: [BoxSchema]
});

module.exports = mongoose.model('Sector', SectorSchema);
