express  = require("express")
router   = express.Router()
_        = require("lodash")
ObjectId = require("mongoose").Types.ObjectId

Sector = require("../models/sector")

# Home action, with available boxes
# for each sector
router.get "/", (req, res) ->
  # find sectors
  Sector.find().populate('boxes').exec (err, sectors) ->
    return console.error err if err

    # prepare data for view
    sector_data = sectors.map (sector) ->
      _id        : String(sector._id)
      name       : sector.name
      description: sector.description
      available  : sector.getAvailable().length
      status     : sector.getStatus()
      panel_class: 'panel-' + get_panelClass(sector)

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
editAction = (req, res) ->
  unless req.params.sector_id?
    res.render 'sector/form',
      title   : "Lazy Parking"
      pageName: 'sectors'
  else
    Sector.findOne _id: new ObjectId(req.params.sector_id), (err, sector) ->
      return console.error err if err
      res.render 'sector/form',
        title   : "Lazy Parking"
        pageName: 'sectors'
        sector  : sector

# Routes for the fom view
router.get "/add"            , editAction
router.get "/edit/:sector_id", editAction

# Save the sector
router.post "/save", (req, res) ->
  if req.body._id?
    id = new ObjectId(req.body._id)
    Sector.update _id: id, _.omit(req.body, '_id'), (err, sector) ->
      return console.error err if err
      res.redirect '/sectors/index'
  else
    Sector.create req.body, (err, sector) ->
      return console.error err if err
      res.redirect '/sectors/index'

# Delete a sector
router.get "/delete/:sector_id", (req, res) ->
  Sector.findOne _id: new ObjectId(req.params.sector_id), (err, sector) ->
    return console.error err if err
    if sector
      sector.remove (err) ->
        return console.error err if err
        res.redirect '/sectors/index'

###
private functions
###

get_panelClass = (sector) ->
  switch sector.getStatus()
    when 'half' then 'warning'
    when 'full' then 'danger'
    else 'success'

# export module
module.exports = router
