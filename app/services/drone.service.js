var Box, Drone, DroneMethods, _;

DroneMethods = require("../models/droneMethods");

Box = require("../models/box");

_ = require("lodash");

Drone = (function() {
  var _client, _respondOnce, _response;

  _client = null;

  _response = '';

  function Drone(client) {
    _client = client;
    this.respondWith("Hello!");
    _client.on('data', (function(_this) {
      return function(data) {
        var boxId, jsonData, _i, _len, _ref, _results;
        if (data == null) {
          return true;
        }
        jsonData = JSON.parse(data.toString());
        if (_this.validate(jsonData) === false) {
          return false;
        }
        switch (jsonData.method) {
          case DroneMethods.REGISTER:
            if (jsonData.boxes.length === 0) {
              return _this.respondWith("Drone " + jsonData.droneId + " has no boxes");
            } else {
              _ref = jsonData.boxes;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                boxId = _ref[_i];
                _results.push(_this.register(boxId, jsonData.droneId));
              }
              return _results;
            }
            break;
          case DroneMethods.STATUS:
            return _this.setAvaiable(jsonData);
        }
      };
    })(this));
  }

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

  _respondOnce = _.debounce(function(message, callback) {
    return _client.write(_response, callback);
  }, 500);

  Drone.prototype.respondWith = function(message) {
    _response += "" + message + "\n";
    return _respondOnce(_response, function() {
      return _response = '';
    });
  };

  return Drone;

})();

module.exports = Drone;
