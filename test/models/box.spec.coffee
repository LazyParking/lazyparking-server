expect   = require("chai").expect

Box    = require("../../app/models/box")

# start the server
require("../../bin/www")

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
      drone:
        id: 0x31
        address: '0.0.0.0'
    ,
      _id: 0x12
      drone:
        id: 0x31
        address: '0.0.0.0'
    ,
      _id: 0x13
      drone:
        id: 0x32
        address: '0.0.0.0'
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