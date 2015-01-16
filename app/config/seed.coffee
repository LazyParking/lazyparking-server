Box    = require("../models/box")
Sector = require("../models/sector")

# create some boxes
boxes = []
Box.find().remove ->
  for id in [0..9]
    Box.create
      id: id
      droneId: 0x1
      droneAddress: '127.0.0.1',
      occupied: if id < 8 then false else true
    , (err, box) ->
      if err
        console.error err
        return
      boxes.push box._id


# create sectors and add boxes to then
Sector.find().remove ->
  Sector.create
    name : 'Setor de teste 001'
    boxes: boxes
    gate : 'Portão 1'
  ,
    name : 'Setor de teste 002'
    boxes: []
    gate : 'Portão 2'
  , (err) ->
    if err
      console.error err
      return
    console.log 'Finish adding some sectors and boxes'
