env = process.env

module.exports =
  user  : env.MONGODB_USER || ''
  pass  : env.MONGODB_PASS || ''
  server: env.MONGODB_SERVER || env.MONGODB_PORT_27017_TCP_ADDR || 'localhost'
  port  : env.MONGODB_PORT || env.MONGODB_PORT_27017_TCP_PORT || 27017
  name  : env.MONGODB_NAME || 'lazyparking-dev'
