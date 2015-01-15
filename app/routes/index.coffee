express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "index",
    title: "Lazy Parking",
    pageName: 'home'
    sectors: [
      status: 'empty'
      boxes_available: 99
      panel_class: 'panel-success'
    ,
      status: 'empty'
      boxes_available: 99
      panel_class: 'panel-success'
    ,
      status: 'half'
      boxes_available: 99
      panel_class: 'panel-warning'
    ,
      status: 'full'
      boxes_available: 99
      panel_class: 'panel-danger'
    ]

  return

module.exports = router
