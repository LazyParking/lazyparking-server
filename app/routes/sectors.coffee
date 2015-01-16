express = require("express")
router  = express.Router()
_       = require("lodash")

Sector = require("../models/sector")

# Home action, with available boxes
# for each sector
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
      total      : get_status(sector.boxes)

    # render view
    res.render 'sector/home',
      title   : "Lazy Parking"
      pageName: 'home'
      sectors : sector_data

# Full sector index
router.get "/index", (req, res) ->
  # find sectors
  Sector.find (err, sectors) ->
    res.render 'sector/list',
      title   : "Lazy Parking"
      pageName: 'sectors'
      sectors : sectors

# Add/edit sectors
saveAction = (req, res) ->
  unless req.params.sector_id?
    return res.render 'sector/form',
      title   : "Lazy Parking"
      pageName: 'sectors'

  Sector.findOne req.params.sector_id, (err, sector) ->
    return console.error err if err
    res.render 'sector/form',
      title   : "Lazy Parking"
      pageName: 'sectors'
      sector  : sector

router.get "/add"            , saveAction
router.get "/edit/:sector_id", saveAction
router.get "/save"           , saveAction

get_available = (boxes) ->
  available = _.filter boxes, (box) ->
    box.occupied is false

get_status = (boxes) ->
  total = get_available(boxes).length / boxes.length
  status = switch
    when total <= 0.50 then 'half'
    when total <= 0.25 then 'full'
    else 'empty'

get_panelClass = (boxes) ->
  switch get_status(boxes)
    when 'half' then 'warning'
    when 'full' then 'danger'
    else 'success'

module.exports = router
