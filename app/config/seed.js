var Box, Sector, boxes, id, _i;

Box = require("../models/box");

Sector = require("../models/sector");

boxes = [];

for (id = _i = 0; _i <= 9; id = ++_i) {
  boxes.push(new Box({
    id: id,
    avaiable: true,
    drone: 0x1
  }));
}

Sector.find().remove(function() {
  return Sector.create({
    id: 0,
    name: 'Sem setor',
    boxes: []
  }, {
    id: 0x1,
    name: 'Setor de teste 001',
    boxes: boxes
  }, function() {
    return console.log('Finish adding some boxes in sector');
  });
});
