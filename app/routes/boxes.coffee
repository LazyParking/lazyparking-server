express = require("express")
router = express.Router()

Box = require("../models/box")

# GET users listing.
router.get "/", (req, res) ->
  Box.find {}, (err, data) ->
    console.log err if err
    res.render 'boxes/list',
      boxes: data,
      title: "Lazy Parking",
      pageName: 'boxes'
  return

module.exports = router
