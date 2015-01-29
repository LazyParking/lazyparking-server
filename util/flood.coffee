# This is a flood script just for testing
# purposes.
# I'll flood random availability of boxes for the
# defined server and por util the process is killed.

minimist = require('minimist')
net = require('net')

argv = minimist process.argv[2..],
  boolean: ['help']
  alias:
    help: ['?']
    host: ['h']
    port: ['p']
    boxes: ['b']
    drones: ['d']
  default:
    help: false
    host: null
    port: null
    boxes: 1
    drones: 1
    delay: 1000

# If asked for help, print commands and exit
if argv.help is true
  console.log """
  -?
  --help    This help
  -h
  --host    Host address to connect
  -p
  --port    Port to connect to
  -b
  --boxes   Number of boxes to send (default: 1)
  -d
  --drones  Number of drones to send (default: 1)
  --delay   Time between requests, in miliseconds (default: 1000)

  Example:
  coffee flood.coffee -h localhost -p 3030 -b 10 -d 2
  """
  process.exit 0

# require options
unless argv.host? or argv.port?
  console.error 'Option not provided. Required options are: host, port'
  process.exit 0

# return a random box
box   = ->
  Math.floor(Math.random() * argv.boxes)

# return a random drone
drone = ->
  Math.floor(Math.random() * argv.drones) + 1

# return a random status between true | false
status = ->
  Boolean Math.floor(Math.random() * 2)

# repeat action until quit
setInterval ->
  # connect to the server
  client = net.connect
    host: argv.host
    port: argv.port
  , ->
    data = JSON.stringify
      droneId : drone()
      boxId   : box()
      occupied: status()
    console.log "sending #{data}"
    client.write data
    # end after 400ms
    setTimeout ( -> client.end() ), 400
, argv.delay
