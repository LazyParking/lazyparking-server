Box    = require("../models/box")
Sector = require("../models/sector")

# create some boxes
boxes = []
for id in [0..9]
  boxes.push new Box
    boxId: id
    avaiable: true
    droneId: 0x1

# create sectors and add boxes to then
Sector.find().remove ->
  Sector.create
    sectorId: 0
    name: 'Sem setor'
    orphan: true
    boxes: []
  ,
    sectorId: 0x1
    name: 'Setor de teste 001'
    boxes: boxes
  , ->
    console.log 'Finish adding some sectors and boxes'