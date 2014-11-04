var Box, Drone, DroneMethods, _;

DroneMethods = require("../models/droneMethods");

Box = require("../models/box");

_ = require("lodash");

Drone = (function() {
  var _client;

  _client = null;

  function Drone(client) {
    var stringData;
    _client = client;
    stringData = '';
    _client.on('data', function(data) {
      if (data == null) {
        return true;
      }
      stringData += data.toString();
      return this.process(stringData);
    });
  }

  Drone.prototype.process = _.debounce(function(stringData) {
    var boxId, data, _i, _len, _ref, _results;
    data = JSON.parse(stringData);
    if (this.validate(data) === false) {
      return false;
    }
    switch (data.method) {
      case DroneMethods.REGISTER:
        if (data.boxes.length === 0) {
          return this.respondWith("Drone " + data.droneId + " has no boxes");
        } else {
          _ref = data.boxes;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            boxId = _ref[_i];
            _results.push(this.register(boxId, data.droneId));
          }
          return _results;
        }
        break;
      case DroneMethods.STATUS:
        return this.setAvaiable(data);
    }
  }, 500);

  Drone.prototype.register = function(boxId, droneId) {
    return Box.findOne({
      _id: boxId
    }, (function(_this) {
      return function(err, box) {
        if (err != null) {
          return _this.handleError(err);
        }
        if (box != null) {
          if (box.drone.id === droneId) {
            return _this.respondWith("Box " + boxId + " already registered for Drone " + droneId);
          } else {
            box.drone = {
              id: droneId,
              address: _client.address().address
            };
            return box.save(function(err) {
              if (err != null) {
                return _this.handleError(err);
              }
              return _this.respondWith("Box " + boxId + " moved to Drone " + droneId);
            });
          }
        } else {
          return Box.create({
            _id: boxId,
            drone: {
              id: droneId,
              address: _client.address().address
            }
          }, function(err) {
            if (err != null) {
              return _this.handleError(err);
            }
            return _this.respondWith("Box " + boxId + " registered for Drone " + droneId);
          });
        }
      };
    })(this));
  };

  Drone.prototype.setAvaiable = function(data) {};

  Drone.prototype.validate = function(data) {
    var b, _i, _len, _ref, _ref1;
    if (typeof data.method !== 'string') {
      this.respondWith("Method not defined. " + (JSON.stringify(data)));
      return false;
    }
    if (typeof data.droneId !== 'number') {
      this.respondWith("Drone id not defined. " + (JSON.stringify(data)));
      return false;
    }
    switch (data.method) {
      case DroneMethods.REGISTER:
        if (!data.boxes instanceof Array) {
          this.respondWith("Boxes not defined. " + (JSON.stringify(data)));
          return false;
        }
        _ref = data.boxes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          b = _ref[_i];
          if (typeof b !== 'number') {
            this.respondWith("Bix id not defined. " + (JSON.stringify(data)));
            return false;
          }
        }
        break;
      case DroneMethods.STATUS:
        if (typeof data.boxId !== 'number') {
          this.respondWith("Box id not defined. " + (JSON.stringify(data)));
          return false;
        }
        if ((_ref1 = data.avaible) !== 0 && _ref1 !== 1) {
          this.respondWith("Invalid value for avaiable. " + (JSON.stringify(data)));
          return false;
        }
        break;
      default:
        this.respondWith("Invalid method. " + (JSON.stringify(data)));
        return false;
    }
    return true;
  };

  Drone.prototype.handleError = function(err) {
    if (err != null) {
      this.respondWith(err.message);
      console.error(err.message, err.stack);
      return false;
    }
    return true;
  };

  Drone.prototype.respondWith = function(message, end) {
    if (end == null) {
      end = true;
    }
    _client.write("" + message + "\n");
    if (end === true) {
      return _client.end();
    }
  };

  return Drone;

})();

module.exports = Drone;
