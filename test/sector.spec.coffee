expect   = require("chai").expect
mongoose = require("mongoose")

Sector = require("../app/models/sector")
Box    = require("../app/models/box")

describe 'Sector', ->
  before (done) ->
    Sector.find().remove ->
      done()

  it 'is a sector', ->
    expect(Sector).to.be.a 'function'
    expect(new Sector).to.be.instanceof Sector

  it 'has no sectors', (done) ->
    Sector.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.a 'array'
      expect(data).to.be.empty
      done()

  it 'fails to add an incomplete sector', (done) ->
    Sector.create
      name: 'invalid sector'  # only the name
    , (err) ->
      expect(err).to.be.not.null
      done()

  it 'fails to add sectors with duplicated ids', (done) ->
    Sector.create
      _id: 0x21
      name: 'sector 1'
      boxes: []
    ,
      _id: 0x21
      name: 'sector 2'
      boxes: []
    , (err) ->
      expect(err).to.be.not.null
      done()


  it 'adds a new empty sector', (done) ->
    Sector.create
      _id: 0x23
      name: 'sector 1'
      boxes: []
    , (err) ->
      expect(err).to.be.null
      done()

  it 'has some sectors', (done) ->
    Sector.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.a 'array'
      expect(data).to.be.not.empty
      done()

  it 'add an empty sector', (done) ->
    Sector.create
      _id: 0x24
      name: 'sector 1'
      boxes: []
    , (err) ->
      expect(err).to.be.null

      Sector.find {_id: 0x24}, (err, data) ->
        sector = data[0]
        expect(sector).to.be.a('object')
        expect(sector.boxes).to.be.a 'array'
        expect(sector.boxes).to.have.length(0)
        done()


describe 'Box', ->
  before (done) ->
    Box.find().remove ->
      done()

  it 'is a Box', ->
    expect(Box).to.be.a 'function'
    expect(new Box).to.be.instanceof Box

  it 'has no boxes', (done) ->
    Box.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.empty
      done()

  it 'add some boxes', (done) ->
    Box.create
      _id: 0x11
      droneId: 0x31
    ,
      _id: 0x12
      droneId: 0x31
    ,
      _id: 0x13
      droneId: 0x32
    , (err) ->
      expect(err).to.be.null
      done()

  it 'find boxes wherever they are', (done) ->
    Box.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.a 'array'
      expect(data).to.be.not.empty
      done()

  it 'find a box by id: 0x11'

  it 'deletes a box'

describe 'Sector'  , ->
  it 'add three boxes to 0x24', (done) ->
    Sector.find {_id: 0x24}, (err, data) ->
      sector = data[0]
      sector.boxes.push 0x11, 0x12, 0x13
      sector.save (err) ->
        expect(err).to.be.null
        done()

  it 'has three boxes on 0x24', (done) ->
    Sector.find {_id: 0x24}, (err, data) ->
      sector = data[0]
      expect(sector.boxes).to.be.a 'array'
      expect(sector.boxes).to.have.length(3)
      done()

  it 'has boxes as children'

  it 'move a box to another sector'