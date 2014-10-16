var app, bodyParser, cookieParser, express, favicon, logger, path;

express = require("express");

path = require("path");

favicon = require("serve-favicon");

logger = require("morgan");

cookieParser = require("cookie-parser");

bodyParser = require("body-parser");

app = express();

app.set("views", path.join(__dirname, "views"));

app.set("view engine", "jade");

app.use(logger("dev"));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(express["static"](path.join(__dirname, "public")));


/*
Application routes goes here

Add for each route/*
 */

app.use("/", require("./routes/index"));

app.use("/users", require("./routes/users"));

app.use(function(req, res, next) {
  var err;
  err = new Error("Not Found");
  err.status = 404;
  next(err);
});

if (app.get("env") === "development") {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render("error", {
      message: err.message,
      error: err
    });
  });
}

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render("error", {
    message: err.message,
    error: {}
  });
});

module.exports = app;
