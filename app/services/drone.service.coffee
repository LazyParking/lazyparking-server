debug        = require('debug')('lazyparking-server')
error        = require('debug')('lazyparking-server:error')
_            = require("lodash")

DroneMethods = require("../models/droneMethods")
Box          = require("../models/box")

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

    # evento 'data', executa o @process
    _client.on 'data', (data) =>
      return true if not data?
      debug "Server received: #{data.toString()}"
      try
        jsonData = JSON.parse data.toString()
      catch e
        @respondWith "Invalid data received"
        @handleError e
        return false
      return false if @validate(jsonData) is false

      @setAvaiable jsonData

  # Registra um box na base de dados
  register: (data) ->
    Box.create
      id: data.boxId
      droneId: data.droneId
      droneAddress: _client.remoteAddress
      occupied: data.occupied
    , (err) =>
      return @handleError(err) if err?
      @respondWith "Box #{data.boxId} registered for Drone #{data.droneId}"
      @respondWith "Box #{data.boxId} marked as #{
        if data.occupied in [1, true]
          'occupied'
        else
          'available'
      }"

  # Marca um box como livre ou ocupado
  setAvaiable: (data) ->
    Box.findOne {id: data.boxId, droneId: data.droneId}, (err, box) =>
      return @handleError(err) if err?
      # se encontrou, atualiza o estado
      if box?
        box.occupied = data.occupied
        box.save (err) =>
          return @handleError(err) if err?
          @respondWith "Box #{data.boxId} marked as #{
            if data.occupied in [1, true]
              'occupied'
            else
              'available'
          }"
      else
        # box not found, register
        @register data

  # Valida se os dados enviados são corretos
  validate: (data) ->
    if typeof data.droneId isnt 'number'
      @respondWith "Drone id not defined. #{JSON.stringify data}"
      return false

    if typeof data.boxId isnt 'number'
      @respondWith "Box id not defined. #{JSON.stringify data}"
      return false

    if data.occupied not in [0, 1, false, true]
      @respondWith "Invalid value for occupied. #{JSON.stringify data}"
      return false

    true

  # Trata dos erros ocorridos
  handleError: (err) ->
    if err?
      # @respondWith err.message
      debug "Error: #{err.message}"
      error "Stack: #{err.stack}"
      return false
    return true

  # @private
  _respondOnce = _.debounce (message, callback) ->
    debug "Server responded: #{message}"
    try
      _client.write _response, callback
    catch e
      callback e
  , 100 # TODO: usar uma config ou ENV

  # Envia uma mensagem para o Drone
  # @param {string} message
  respondWith: (message) ->
    _response += "#{message}\n"
    _respondOnce _response, (err) =>
      return @handleError err if err?
      _response = ''

# exporta a classe
module.exports = Drone