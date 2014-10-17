var Box, Sector, boxes, id, _i;

Box = require("../models/box");

Sector = require("../models/sector");

boxes = [];

for (id = _i = 0; _i <= 9; id = ++_i) {
  boxes.push(new Box({
    boxId: id,
    avaiable: true,
    droneId: 0x1
  }));
}

Sector.find().remove(function() {
  return Sector.create({
    sectorId: 0,
    name: 'Sem setor',
    orphan: true,
    boxes: []
  }, {
    sectorId: 0x1,
    name: 'Setor de teste 001',
    boxes: boxes
  }, function() {
    return console.log('Finish adding some sectors and boxes');
  });
});
