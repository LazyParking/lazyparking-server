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

  it 'register a box 01 for drone 42 and mark as occupied', (done) ->
    client.write JSON.stringify
      droneId: 42
      boxId: 1
      occupied: true
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 1 registered for Drone 42'
      expect(data.toString()).to.contain.string 'Box 1 marked as occupied'
      Box.findOne {"_id": 1}, (err, data) ->
        expect(data).to.have.property 'occupied', true
        done()

  it 'register a box 02 for done 123 and mark available', (done) ->
    client.write JSON.stringify
      droneId: 123
      boxId: 2
      occupied: false
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 2 registered for Drone 123'
      expect(data.toString()).to.contain.string 'Box 2 marked as available'
      Box.findOne {"_id": 2}, (err, data) ->
        expect(data).to.have.property 'occupied', false
        done()

  it 'mark box 01 as available', (done) ->
    client.write JSON.stringify
      droneId: 42
      boxId: 1
      occupied: false
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 1 marked as available'
      Box.findOne {"_id": 1}, (err, data) ->
        expect(data).to.have.property 'occupied', false
        done()

  it 'mark box 02 as occupied', (done) ->
    client.write JSON.stringify
      droneId: 123
      boxId: 2
      occupied: true
    client.on 'data', (data) ->
      expect(data.toString()).to.contain.string 'Box 2 marked as occupied'
      Box.findOne {"_id": 3}, (err, data) ->
        expect(data).to.have.property 'occupied', true
        done()

  afterEach 'end the net client', ->
    client.end()
