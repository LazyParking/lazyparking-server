express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render "index",
    title: "Lazy Parking",
    pageName: 'home'

  return

module.exports = router