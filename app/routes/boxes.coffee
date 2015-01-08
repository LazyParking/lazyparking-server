express = require("express")
router = express.Router()

Box = require("../models/box")

# GET users listing.
router.get "/", (req, res) ->
  Box.find {}, (err, data) ->
    console.log err if err
    res.render 'box/list',
      boxes: data,
      title: "Lazy Parking"
  return

module.exports = router