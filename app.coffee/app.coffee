express      = require("express")
path         = require("path")
favicon      = require("serve-favicon")
logger       = require("morgan")
cookieParser = require("cookie-parser")
bodyParser   = require("body-parser")
mongoose     = require("mongoose")

app          = express()

###
Connect to mongodb
###
mongodb_uri = "
  mongodb://#{process.env.MONGODB_USER}:#{process.env.MONGODB_PASS}
  @#{process.env.MONGODB_SERVER}:#{process.env.MONGODB_PORT}
  /#{process.env.MONGODB_NAME}"
mongoose.connect mongodb_uri

# Add test data to database
if process.env.NODE_ENV == 'dev'
  require('./config/seed')

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, "public"))

###
Application routes goes here

Add for each route/*
###
app.use "/", require("./routes/index")
app.use "/users", require("./routes/users")

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return

# error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err
    return


# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}
  return

module.exports = app