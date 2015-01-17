express  = require("express")
router   = express.Router()
ObjectId = require("mongoose").Types.ObjectId
moment   = require("moment")

Sector = require("../models/sector")
Box    = require("../models/box")

# Index action/listing
indexAction = (req, res) ->
  Box.find().sort('droneId, id').populate('sector').exec (err, boxes) ->
    console.log err if err
    res.render 'boxes/list',
      title   : "Lazy Parking"
      pageName: 'boxes'
      boxes   : boxes
      moment  : moment  # allow use moment on the view

# Routes for index
router.get "/"     , indexAction
router.get "/index", indexAction

# edits a box
router.get "/edit/:box_id", (req, res) ->
  Sector.find (err, sectors) ->
    return console.error err if err

    Box.findOne _id: new ObjectId(req.params.box_id), (err, box) ->
      return console.error err if err
      res.render 'box/form',
        title   : "Lazy Parking"
        pageName: 'boxes'
        box     : box
        sectors : sectors

# Save the box
router.post "/save", (req, res) ->
  if req.body._id?
    box_id    = new ObjectId(req.body._id)
    sector_id = new ObjectId(req.body.sector)
    # find the box
    Box.findOne _id: box_id, (err, box) ->
      return console.error err if err
      # find the old sector
      if box.sector
        Sector.findOne _id: box.sector, (err, sector) ->
          return console.error err if err
          sector.removeBox box._id, (err) ->
            return console.error err if err
      # find the new sector
      Sector.findOne _id: sector_id, (err, sector) ->
        return console.error err if err
        sector.addBox box_id, (err) ->
          return console.error err if err
      # update box
      box.update { sector: sector_id }, (err) ->
        return console.error err if err
        res.redirect '/boxes/index'

# Deletes a box
router.get "/delete/:box_id", (req, res) ->
  Box.findOne _id: new ObjectId(req.params.box_id), (err, box) ->
    return console.error err if err
    if box
      if box.sector
        # find the old sector
        Sector.findOne _id: box.sector, (err, sector) ->
          return console.error err if err
          sector.removeBox box._id, (err) ->
            return console.error err if err
      # remove box
      box.remove (err) ->
        return console.error err if err
        res.redirect '/boxes/index'

module.exports = router
