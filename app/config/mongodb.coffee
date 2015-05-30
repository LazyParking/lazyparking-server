env = process.env

module.exports =
  uri   : process.env.MONGOLAB_URI
  server: env.MONGO_SERVER_ADDRESS ||
          env.MONGO_PORT_27017_TCP_ADDR || 'localhost'
  port  : env.MONGO_PORT_NUMBER ||
          env.MONGO_PORT_27017_TCP_PORT || 27017
  user  : env.MONGO_DB_USERNAME || ''
  pass  : env.MONGO_DB_PASSWORD || ''
  name  : env.MONGO_DB_NAME || 'lazyparking-dev'
