Box    = require("../models/box")
Sector = require("../models/sector")

# create some boxes
boxes = []
for id in [0..9]
  boxes.push new Box
    id: id
    avaiable: true
    drone: 0x1

# create sectors and add boxes to then
Sector.find().remove ->
  Sector.create
    id: 0
    name: 'Sem setor'
    boxes: []
  ,
    id: 0x1
    name: 'Setor de teste 001'
    boxes: boxes
  , ->
    console.log 'Finish adding some boxes in sector'