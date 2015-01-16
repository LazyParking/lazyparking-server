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
      status     : get_status(sector.boxes) #'empty'
      panel_class: 'panel-' + get_panelClass(sector.boxes)
      total : get_status(sector.boxes)

    # render view
    res.render 'sector/list',
      title: "Lazy Parking"
      pageName: 'home'
      sectors: sector_data

get_available = (boxes) ->
  available = _.filter boxes, (box) ->
    box.occupied is false

get_status = (boxes) ->
  total = get_available(boxes).length / boxes.length
  console.log total
  status = switch
    when total < 0.50 then 'half'
    when total < 0.25 then 'full'
    else 'empty'

get_panelClass = (boxes) ->
  message = get_status(boxes)
  newClass = switch
    when message is 'half' then 'warning'
    when message is 'full' then 'danger'
    else 'success'

module.exports = router
