express = require("express")
router = express.Router()

# GET home page.
router.get "/:name", (req, res) ->
  res.render "pages/#{req.params.name}",
    title: "Lazy Parking",
    pageName: req.params.name

  return

module.exports = router
