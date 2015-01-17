express  = require("express")
router   = express.Router()
ObjectId = require('mongoose').Types.ObjectId

Box = require("../models/box")

# Index action/listing
indexAction = (req, res) ->
  Box.find (err, boxes) ->
    console.log err if err
    res.render 'boxes/list',
      title   : "Lazy Parking"
      pageName: 'boxes'
      boxes   : boxes

# Routes for index
router.get "/"     , indexAction
router.get "/index", indexAction

# Deletes a box
router.get "/delete/:box_id", (req, res) ->
  Box.findOne _id: new ObjectId(req.params.box_id), (err, box) ->
    return console.error err if err
    if box
      box.remove (err) ->
        return console.error err if err
        res.redirect '/boxes/index'

module.exports = router
