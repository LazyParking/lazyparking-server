expect = require("chai").expect

describe "Sector", ->
  Sector = require("../app/models/sector")

  it "adds a new sector", (done) ->
    Sector.create
      id: 0x23
      name: 'foobar'
      boxes: []
    , ->
      done()

  it "has some sectors", (done) ->
    Sector.find (err, data) ->
      expect(data).to.be.a("array")
      expect(data).to.not.be.empty
      done()