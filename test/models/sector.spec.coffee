expect   = require("chai").expect

Sector = require("../../app/models/sector")
Box    = require("../../app/models/box")

# start the server
require("../../bin/www")

describe 'Sector', ->
  before (done) ->
    Sector.find().remove done

  it 'is a sector', ->
    expect(Sector).to.be.a 'function'
    expect(new Sector).to.be.instanceof Sector

  it 'has no sectors', (done) ->
    Sector.find (err, data) ->
      expect(err).to.be.null
      expect(data).to.be.an 'array'
      expect(data).to.be.empty
      done()

  it.skip 'cannot add an incomplete sector', (done) ->
    Sector.create
      name: 'invalid sector'  # only the name
    , (err) ->
      expect(err).to.be.not.null
      done()

  it 'add an empty sector', (done) ->
    Sector.create
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

  it.skip 'add a new empty sector', (done) ->
    Sector.create
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
        id: 0x11
        droneId: 0x31,
        droneAddress: '0.0.0.0'
      ,
        id: 0x12
        droneId: 0x31,
        droneAddress: '0.0.0.0'
      ,
        id: 0x13
        droneId: 0x32,
        droneAddress: '0.0.0.0'
      , done

  it.skip 'add three boxes to 0x23', (done) ->
    Sector.findOne {_id: 0x23}, (err, sector) ->
      Box.find (err, boxes) ->
        sector.boxes.push (boxes.map (box) -> box._id)...
        sector.save (err) ->
          expect(err).to.be.null
          done()

  it.skip 'has three boxes on 0x23', (done) ->
    Sector.findOne {_id: 0x23}, (err, sector) ->
      expect(sector.boxes).to.be.an 'array'
      expect(sector.boxes).to.have.length(3)
      done()

  it.skip 'has boxes as children', (done) ->
    Sector.findOne(_id: 0x23)
    .populate('boxes')
    .exec (err, sector) ->
      expect(sector.boxes).to.be.an 'array'
      expect(sector.boxes).to.be.not.empty
      expect(box).to.instanceof Box for box in sector.boxes
      done()


  it 'move a box to another sector'
