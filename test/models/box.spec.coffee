expect   = require("chai").expect

Box    = require("../../app/models/box")

# start the server
require("../../bin/www")

describe 'Box', ->
  before (done) ->
    Box.find().remove done

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
      id: 0x11
      droneId: 0x31
      droneAddress: '0.0.0.0'
    ,
      id: 0x12
      droneId: 0x31
      droneAddress: '0.0.0.0'
    ,
      id: 0x13
      droneId: 0x32
      droneAddress: '0.0.0.0'
    , (err) ->
      console.error err.message if err
      expect(err).to.be.null
      done()

  it 'find boxes wherever they are', (done) ->
    Box.find (err, data) ->
      console.error err.message if err
      expect(err).to.be.null
      expect(data).to.be.an 'array'
      expect(data).to.be.not.empty
      done()

  it 'find a box by id: 0x11'

  it 'deletes a box'