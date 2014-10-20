expect   = require("chai").expect

Box    = require("../app/models/box")

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
      expect(data).to.be.an 'array'
      expect(data).to.be.not.empty
      done()

  it 'find a box by id: 0x11'

  it 'deletes a box'