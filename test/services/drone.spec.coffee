expect = require("chai").expect
net    = require("net")
spawn  = require("child_process").spawn

Sector = require("../../app/models/sector")
Box    = require("../../app/models/box")

# start the server
require("../../bin/www")

describe 'Drone', ->
  client       = null
  responseData = null

  before 'remove all boxes', (done) ->
    Box.find().remove done

  beforeEach 'start the net client', (done) ->
    responseData = ''
    client = net.connect {port: process.env.SERV_PORT or 3030}, ->
      done()

  it 'try to register a new drone (666) without boxes', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 666
      boxes: []
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Drone 666 has no boxes'
      # check db
      Box.find (err, data) ->
        expect(data).to.be.empty
        done()

  it 'register a new drone (666) with only one box (99)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 666
      boxes: [99]
    client.on 'data', (data) ->
      expect(data.toString()).to.contain
        .string 'Box 99 registered for Drone 666'
      # check db
      Box.findOne {_id: 99}, (err, data) ->
        expect(data).to.have.deep.property 'drone.id', 666
        done()

  it 'register a new drone (42) with 4 new boxes \
    (01, 02, 03, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 42
      boxes: [1, 2, 3, 4]
    calls = 0
    client.on 'data', (data) ->
      expect(data.toString())
        .to.contain.string 'Box 1 registered for Drone 42'
        .to.contain.string 'Box 2 registered for Drone 42'
        .to.contain.string 'Box 3 registered for Drone 42'
        .to.contain.string 'Box 4 registered for Drone 42'
      # check db
      Box.find {"drone.id": 42}, (err, data) ->
        expect(data).to.have.length 4
        done()

  it 'register an existent drone (42) with 4 existent boxes \
    (01, 02, 03, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 42
      boxes: [1, 2, 3, 4]
    client.on 'data', (data) ->
      expect(data.toString())
        .to.contain.string 'Box 1 already registered for Drone 42'
        .to.contain.string 'Box 2 already registered for Drone 42'
        .to.contain.string 'Box 3 already registered for Drone 42'
        .to.contain.string 'Box 4 already registered for Drone 42'
      done()

  it 'register a new drone (123) with 2 existent boxes (02, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 123
      boxes: [2, 4]
    client.on 'data', (data) ->
      expect(data.toString())
        .to.contain.string 'Box 2 moved to Drone 123'
        .to.contain.string 'Box 4 moved to Drone 123'
      # check db
      Box.find {"_id": {"$in": [2, 4]}}, (err, data) ->
        expect(b).to.have.deep.property 'drone.id', 123 for b in data
        done()

  it 'mark box 01 as occupied', (done) ->
    client.write JSON.stringify
      method: "s"
      droneId: 42
      boxId: 1
      avaiable: 0
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 1 marked as occupied'
      Box.findOne {"_id": 1}, (err, data) ->
        expect(data).to.have.property 'avaiable', false
        done()

  it 'mark box 02 as occupied', (done) ->
    client.write JSON.stringify
      method: "s"
      droneId: 123
      boxId: 2
      avaiable: false
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 2 marked as occupied'
      Box.findOne {"_id": 2}, (err, data) ->
        expect(data).to.have.property 'avaiable', false
        done()

  it 'mark box 01 as avaiable', (done) ->
    client.write JSON.stringify
      method: "s"
      droneId: 42
      boxId: 1
      avaiable: 1
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 1 marked as avaiable'
      Box.findOne {"_id": 1}, (err, data) ->
        expect(data).to.have.property 'avaiable', true
        done()

  it 'mark box 03 as avaiable', (done) ->
    client.write JSON.stringify
      method: "s"
      droneId: 42
      boxId: 3
      avaiable: true
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 3 marked as avaiable'
      Box.findOne {"_id": 3}, (err, data) ->
        expect(data).to.have.property 'avaiable', true
        done()

  afterEach 'end the net client', ->
    client.end()
