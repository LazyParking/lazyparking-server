var BoxSchema, Schema, mongoose;

mongoose = require("mongoose");

Schema = mongoose.Schema;

BoxSchema = new Schema({
  boxId: {
    type: Number,
    required: true
  },
  avaiable: {
    type: Boolean,
    "default": false
  },
  droneId: {
    type: Number,
    required: true
  },
  created: {
    type: Date,
    "default": Date.now
  }
});

module.exports = mongoose.model('Box', BoxSchema);
