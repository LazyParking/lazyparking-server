express = require("express")
router = express.Router()

Box = require("../models/box")

# GET users listing.
router.get "/", (req, res) ->
  Box.find {}, (err, data) ->
    console.log err if err
    res.render 'box/list', boxes: data
  return

module.exports = router