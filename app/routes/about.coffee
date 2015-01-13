express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render 'pages/about',
    title: "Lazy Parking",
    pageName: 'about'

  return

module.exports = router