express = require("express")
router = express.Router()

# GET home page.
router.get "/", (req, res) ->
  res.render 'pages/contact',
    title: "Lazy Parking",
    pageName: 'contact'

  return

module.exports = router