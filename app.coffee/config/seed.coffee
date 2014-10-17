Box    = require("../models/box")
Sector = require("../models/sector")

# create some boxes
boxes = []
Box.find().remove ->
  for id in [0..9]
    boxes.push id
    Box.create
      _id: id
      avaiable: true
      droneId: 0x1
    , (err) ->
      if err
        console.error err
        return


# create sectors and add boxes to then
Sector.find().remove ->
  Sector.create
    _id: 0
    name: 'Sem setor'
    boxes: []
  ,
    _id: 0x1
    name: 'Setor de teste 001'
    boxes: boxes
  , (err) ->
    if err
      console.error err
      return
    console.log 'Finish adding some sectors and boxes'