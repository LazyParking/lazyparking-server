var Box, express, router;

express = require("express");

router = express.Router();

Box = require("../models/box");

router.get("/", function(req, res) {
  Box.find({}, function(err, data) {
    if (err) {
      console.log(err);
    }
    return res.render('box/list', {
      boxes: data
    });
  });
});

module.exports = router;
