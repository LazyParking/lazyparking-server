DroneMethods = require("../models/droneMethods")
Box          = require("../models/box")

# Recebe as informações do Drone
class Drone
  # cliente TCP
  client: null

  # O contrutor adiciona referencia local para o cliente
  # e executa o método solicitado
  constructor: (@client) ->
    # envia um "alô"
    @send "Hello!"

    @client.on 'data', (clientData) =>
      data = JSON.parse clientData.toString()
      return false if @validate(data) is false

      switch data.method
        when DroneMethods.REGISTER
          if data.boxes.length is 0
            @send "Drone #{data.droneId} has no boxes"
          else
            for boxId in data.boxes
              @register boxId, data.droneId

        when DroneMethods.STATUS
          @setAvaiable data
        
  # Registra um box na base de dados
  register: (boxId, droneId) ->
    Box.findOne {_id: boxId}, (err, box) =>
      return @handleError(err) if err?
      # se encontrou
      if box?
        # primeiro verifica se é o mesmo drone
        if box.drone.id == droneId
          @send "Box #{boxId} already registered for Drone #{droneId}"
        # se não for, atualiza
        else
          box.drone =
            id: droneId
            address: @client.address().address
          box.save (err) =>
            return @handleError(err) if err?
            @send "Box #{boxId} moved to Drone #{droneId}"
      # se não encontrar, registra novo
      else
        Box.create
          _id: boxId
          drone:
            id: droneId
            address: @client.address().address
        , (err) =>
          return @handleError(err) if err?
          @send "Box #{boxId} registered for Drone #{droneId}"

  # Marca um box como livre ou ocupado
  setAvaiable: (data) ->

  # Valida se os dados enviados são corretos
  validate: (data) ->
    if typeof data.method isnt 'string'
      @send "Method not defined. #{JSON.stringify data}"
      return false

    if typeof data.droneId isnt 'number'
      @send "Drone id not defined. #{JSON.stringify data}"
      return false

    switch data.method
      when DroneMethods.REGISTER
        if not data.boxes instanceof Array
          @send "Boxes not defined. #{JSON.stringify data}"
          return false

        for b in data.boxes
          if typeof b isnt 'number'
            @send "Bix id not defined. #{JSON.stringify data}"
            return false

      when DroneMethods.STATUS
        if typeof data.boxId isnt 'number'
          @send "Box id not defined. #{JSON.stringify data}"
          return false

        if data.avaible not in [0, 1]
          @send "Invalid value for avaiable. #{JSON.stringify data}"
          return false

      else
        @send "Invalid method. #{JSON.stringify data}"
        return false

    true

  # Trata dos erros ocorridos
  handleError: (err) ->
    if err?
      @send err.message
      console.error err.message, err.stack
      return false
    return true

  # Envia uma mensagem para o Drone
  send: (message) ->
    @client.write "#{message}\n"

# exporta a classe
module.exports = Drone