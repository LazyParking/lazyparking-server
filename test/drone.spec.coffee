expect = require("chai").expect
net    = require("net")

Sector = require("../app/models/sector")
Box    = require("../app/models/box")

# start the server
lazypark = require("../bin/www")

# describe 'Drone', ->
describe.only 'Drone', ->
  client     = null
  responseData = null

  before 'remove all boxes', (done) ->
    Box.find().remove done

  beforeEach 'start the net client', (done) ->
    responseData = ''
    client = net.connect {port: process.env.SERV_PORT or 3030}, ->
      done()
    client.on 'data', (data) ->
      responseData += data.toString()

  it 'handshakes', (done) ->
    client.on 'end', ->
      expect(responseData).to.contain.string 'Hello!'
      done()
    # client.end()

  it 'try to register a new drone (666) without boxes', (done) ->
    client.on 'end', ->
      expect(responseData).to.contain.string 'Drone 666 has no boxes'
      done()
    client.write JSON.stringify
      method: "r"
      droneId: 666
      boxes: []

  it.skip 'register a new drone (666) with only one box (99)', (done) ->
    client.on 'end', ->
      expect(responseData).to.contain.string 'Box 99 registered for Drone 666'
      done()
    client.end JSON.stringify
      method: "r"
      droneId: 666
      boxes: [99]

  it.skip 'register a new drone (42) with 4 new boxes \
    (01, 02, 03, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 42
      boxes: [1, 2, 3, 4]
    calls = 0
    client.on 'data', (data) ->
      expect(data.toString()).to.match /Box [1-4] registered for Drone 42/
      done()

  it.skip 'register an existent drone (42) with 4 existent boxes \
    (01, 02, 03, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 42
      boxes: [1, 2, 3, 4]
    client.on 'data', (data) ->
      expect(data.toString()).to
        .match /Box [1-4] already registered for Drone 42/
      done()

  it.skip 'register a new drone (123) with 2 existent boxes (02, 04)', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 123
      boxes: [2, 4]
    client.on 'data', (data) ->
      res = data.toString()
      expect(res).to.contain.string 'Boxes 2, 4 moved to Drone 123'
      done()

  it.skip 'removes box 02 from drone 123', (done) ->
    client.write JSON.stringify
      method: "r"
      droneId: 123
      boxes: [4]  # Box 2 is not send on registeration, so
                  # it is treated as removed
    client.on 'data', (data) ->
      res = data.toString()
      expect(res).to.contain.string 'Boxes 2 removed from Drone 123'
      expect(res).to.contain.string 'Boxes 4 already registered for Drone 123'
      done()

  it 'mark box 01 as ocupied'

  it 'mark box 02 as ocupied'

  it 'mark box 01 as avaiable'
