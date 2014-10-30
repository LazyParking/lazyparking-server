# Classe que apenas faz echo de mensagens
class Echo
  # cliente TCP
  client: null

  # O contrutor inicializa as propriedades
  # e adicionar o eventos e pipe
  constructor: (@client) ->
    # envia um "alô"
    @client.write "Hello!\r\n"

    # Para depuração, loga as mensagens no server
    @client.on 'data', (data) ->
      process.stdout.write "client sent: #{data.toString()}"

    # Apenas ecoa as mensagens,
    # enviando de volta para o cliente
    @client.pipe @client

# exporta a classe
module.exports = Echo