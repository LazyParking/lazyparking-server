express = require("express")
router  = express.Router()
_       = require("lodash")

Sector = require("../models/sector")

# GET users listing.
router.get "/", (req, res) ->
  # find sectors
  Sector.find().populate('boxes').exec (err, sectors) ->
    return console.error err if err

    # prepare data for view
    sector_data = sectors.map (sector) ->
      name       : sector.name
      available  : get_available(sector.boxes).length
      status     : 'empty'
      panel_class: 'panel-success'

    # render view
    res.render 'sector/list',
      title: "Lazy Parking"
      pageName: 'home'
      sectors: sector_data

get_available = (boxes) ->
  available = _.filter boxes, (box) ->
    box.occupied is false


module.exports = router
