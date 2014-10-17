var Box, Sector, boxes;

Box = require("../models/box");

Sector = require("../models/sector");

boxes = [];

Box.find().remove(function() {
  var id, _i, _results;
  _results = [];
  for (id = _i = 0; _i <= 9; id = ++_i) {
    boxes.push(id);
    _results.push(Box.create({
      _id: id,
      avaiable: true,
      droneId: 0x1
    }, function(err) {
      if (err) {
        console.error(err);
      }
    }));
  }
  return _results;
});

Sector.find().remove(function() {
  return Sector.create({
    _id: 0,
    name: 'Sem setor',
    boxes: []
  }, {
    _id: 0x1,
    name: 'Setor de teste 001',
    boxes: boxes
  }, function(err) {
    if (err) {
      console.error(err);
      return;
    }
    return console.log('Finish adding some sectors and boxes');
  });
});
