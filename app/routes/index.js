var express, router;

express = require("express");

router = express.Router();

router.get("/", function(req, res) {
  res.render("index", {
    title: "Lazy Parking"
  });
});

module.exports = router;
