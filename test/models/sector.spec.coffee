expect   = require("chai").expect

Sector = require("../../app/models/sector")
Box    = require("../../app/models/box")

# start the server
require("../../bin/www")

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
      expect(data).to.be.an 'array'
      expect(data).to.be.empty
      done()

  it 'cannot add an incomplete sector', (done) ->
    Sector.create
      name: 'invalid sector'  # only the name
    , (err) ->
      expect(err).to.be.not.null
      done()

  it 'cannot add sectors with duplicated ids', (done) ->
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

  it 'add an empty sector', (done) ->
    Sector.create
      _id: 0x22
      name: 'sector 1'
      boxes: []
    , (err) ->
      expect(err).to.be.null
      done()

  it 'has some sectors', (done) ->
    Sector.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.an 'array'
      expect(data).to.be.not.empty
      for sector in data
        expect(sector).to.be.instanceof Sector
      done()

  it 'add a new empty sector', (done) ->
    Sector.create
      _id: 0x23
      name: 'sector 1'
      boxes: []
    , (err) ->
      expect(err).to.be.null

      Sector.find {_id: 0x23}, (err, data) ->
        sector = data[0]
        expect(sector).to.be.instanceof Sector
        expect(sector.boxes).to.be.an 'array'
        expect(sector.boxes).to.have.length(0)
        done()

  # add some boxes for the next tests
  before (done) ->
    Box.find().remove ->
      Box.create
        _id: 0x11
        drone:
          id: 0x31,
          address: '0.0.0.0'
      ,
        _id: 0x12
        drone:
          id: 0x31,
          address: '0.0.0.0'
      ,
        _id: 0x13
        drone:
          id: 0x32,
          address: '0.0.0.0'
      , (err) ->
        expect(err).to.be.null
        done()

  it 'add three boxes to 0x23', (done) ->
    Sector.find {_id: 0x23}, (err, data) ->
      sector = data[0]
      sector.boxes.push 0x11, 0x12, 0x13
      sector.save (err) ->
        expect(err).to.be.null
        done()

  it 'has three boxes on 0x23', (done) ->
    Sector.find {_id: 0x23}, (err, data) ->
      sector = data[0]
      expect(sector.boxes).to.be.an 'array'
      expect(sector.boxes).to.have.length(3)
      done()

  it 'has boxes as children', (done) ->
    Sector.find(_id: 0x23)
    .populate('boxes')
    .exec (err, data) ->
      sector = data[0]
      expect(sector.boxes).to.be.an 'array'
      expect(sector.boxes).to.be.not.empty
      for box in sector.boxes
        expect(box).to.instanceof Box
      done()


  it 'move a box to another sector'