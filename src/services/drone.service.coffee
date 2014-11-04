DroneMethods = require("../models/droneMethods")
Box          = require("../models/box")
_            = require("lodash")

# Recebe as informações do Drone
class Drone
  # cliente TCP
  # @private
  _client = null

  # O contrutor adiciona referencia local para o cliente
  # e executa o método solicitado
  constructor: (client) ->
    _client = client

    # envia um "alô"
    # @respondWith "Hello!"

    stringData = ''

    # evento 'data', executa o @process
    _client.on 'data', (data) ->
      return true if not data?
      stringData += data.toString()
      @process stringData
        
  # Processa os dados recebidos após XXXms
  process: _.debounce (stringData) ->
    data = JSON.parse stringData
    return false if @validate(data) is false

    switch data.method
      when DroneMethods.REGISTER
        if data.boxes.length is 0
          @respondWith "Drone #{data.droneId} has no boxes"

        else
          for boxId in data.boxes
            @register boxId, data.droneId

      when DroneMethods.STATUS
        @setAvaiable data
  , 500 # TODO: usar uma config

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

  # Envia uma mensagem para o Drone
  # e fecha a conexão
  # @param {boolean} end fechar a conexão? (padrão: true)
  respondWith: (message, end = true) ->
    _client.write "#{message}\n"
    _client.end() if end is true

# exporta a classe
module.exports = Drone