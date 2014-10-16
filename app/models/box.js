var BoxSchema, Schema, mongoose;

mongoose = require("mongoose");

Schema = mongoose.Schema;

BoxSchema = new Schema({
  id: Number,
  avaiable: Boolean,
  drone: Number
});

module.exports = mongoose.model('Box', BoxSchema);
