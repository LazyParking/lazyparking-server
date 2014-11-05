DroneMethods = require("../models/droneMethods")
Box          = require("../models/box")
_            = require("lodash")

# Recebe as informações do Drone
class Drone
  # cliente TCP
  # @private
  _client = null

  # resposta a ser enviada para cliente
  # @private
  _response = ''

  # O contrutor adiciona referencia local para o cliente
  # e executa o método solicitado
  constructor: (client) ->
    _client = client

    # envia um "alô"
    @respondWith "Hello!"

    # evento 'data', executa o @process
    _client.on 'data', (data) =>
      return true if not data?
      jsonData = JSON.parse data.toString()
      return false if @validate(jsonData) is false

      switch jsonData.method
        when DroneMethods.REGISTER
          if jsonData.boxes.length is 0
            @respondWith "Drone #{jsonData.droneId} has no boxes"

          else
            for boxId in jsonData.boxes
              @register boxId, jsonData.droneId

        when DroneMethods.STATUS
          @setAvaiable jsonData

  # Registra um box na base de dados
  register: (boxId, droneId) ->
    Box.findOne {_id: boxId}, (err, box) =>
      return @handleError(err) if err?
      # se encontrou
      if box?
        # primeiro verifica se é o mesmo drone
        if box.drone.id == droneId
          @respondWith "Box #{boxId} already registered for Drone #{droneId}"
        # se não for, atualiza
        else
          box.drone =
            id: droneId
            address: _client.address().address
          box.save (err) =>
            return @handleError(err) if err?
            @respondWith "Box #{boxId} moved to Drone #{droneId}"
      # se não encontrar, registra novo
      else
        Box.create
          _id: boxId
          drone:
            id: droneId
            address: _client.address().address
        , (err) =>
          return @handleError(err) if err?
          @respondWith "Box #{boxId} registered for Drone #{droneId}"

  # Marca um box como livre ou ocupado
  setAvaiable: (data) ->

  # Valida se os dados enviados são corretos
  validate: (data) ->
    if typeof data.method isnt 'string'
      @respondWith "Method not defined. #{JSON.stringify data}"
      return false

    if typeof data.droneId isnt 'number'
      @respondWith "Drone id not defined. #{JSON.stringify data}"
      return false

    switch data.method
      when DroneMethods.REGISTER
        if not data.boxes instanceof Array
          @respondWith "Boxes not defined. #{JSON.stringify data}"
          return false

        for b in data.boxes
          if typeof b isnt 'number'
            @respondWith "Bix id not defined. #{JSON.stringify data}"
            return false

      when DroneMethods.STATUS
        if typeof data.boxId isnt 'number'
          @respondWith "Box id not defined. #{JSON.stringify data}"
          return false

        if data.avaible not in [0, 1]
          @respondWith "Invalid value for avaiable. #{JSON.stringify data}"
          return false

      else
        @respondWith "Invalid method. #{JSON.stringify data}"
        return false

    true

  # Trata dos erros ocorridos
  handleError: (err) ->
    if err?
      @respondWith err.message
      console.error err.message, err.stack
      return false
    return true

  # @private
  _respondOnce = _.debounce (message, callback) ->
    _client.write _response, callback
  , 500 # TODO: usar uma config ou ENV

  # Envia uma mensagem para o Drone
  # @param {string} message
  respondWith: (message) ->
    _response += "#{message}\n"
    _respondOnce _response, ->
      _response = ''

# exporta a classe
module.exports = Drone