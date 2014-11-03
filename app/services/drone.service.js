var Box, Drone, DroneMethods;

DroneMethods = require("../models/droneMethods");

Box = require("../models/box");

Drone = (function() {
  Drone.prototype.client = null;

  function Drone(client) {
    this.client = client;
    this.send("Hello!");
    this.client.on('data', (function(_this) {
      return function(clientData) {
        var boxId, data, _i, _len, _ref, _results;
        data = JSON.parse(clientData.toString());
        if (_this.validate(data) === false) {
          return false;
        }
        switch (data.method) {
          case DroneMethods.REGISTER:
            if (data.boxes.length === 0) {
              return _this.send("Drone " + data.droneId + " has no boxes");
            } else {
              _ref = data.boxes;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                boxId = _ref[_i];
                _results.push(_this.register(boxId, data.droneId));
              }
              return _results;
            }
            break;
          case DroneMethods.STATUS:
            return _this.setAvaiable(data);
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
            return _this.send("Box " + boxId + " already registered for Drone " + droneId);
          } else {
            box.drone = {
              id: droneId,
              address: _this.client.address().address
            };
            return box.save(function(err) {
              if (err != null) {
                return _this.handleError(err);
              }
              return _this.send("Box " + boxId + " moved to Drone " + droneId);
            });
          }
        } else {
          return Box.create({
            _id: boxId,
            drone: {
              id: droneId,
              address: _this.client.address().address
            }
          }, function(err) {
            if (err != null) {
              return _this.handleError(err);
            }
            return _this.send("Box " + boxId + " registered for Drone " + droneId);
          });
        }
      };
    })(this));
  };

  Drone.prototype.setAvaiable = function(data) {};

  Drone.prototype.validate = function(data) {
    var b, _i, _len, _ref, _ref1;
    if (typeof data.method !== 'string') {
      this.send("Method not defined. " + (JSON.stringify(data)));
      return false;
    }
    if (typeof data.droneId !== 'number') {
      this.send("Drone id not defined. " + (JSON.stringify(data)));
      return false;
    }
    switch (data.method) {
      case DroneMethods.REGISTER:
        if (!data.boxes instanceof Array) {
          this.send("Boxes not defined. " + (JSON.stringify(data)));
          return false;
        }
        _ref = data.boxes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          b = _ref[_i];
          if (typeof b !== 'number') {
            this.send("Bix id not defined. " + (JSON.stringify(data)));
            return false;
          }
        }
        break;
      case DroneMethods.STATUS:
        if (typeof data.boxId !== 'number') {
          this.send("Box id not defined. " + (JSON.stringify(data)));
          return false;
        }
        if ((_ref1 = data.avaible) !== 0 && _ref1 !== 1) {
          this.send("Invalid value for avaiable. " + (JSON.stringify(data)));
          return false;
        }
        break;
      default:
        this.send("Invalid method. " + (JSON.stringify(data)));
        return false;
    }
    return true;
  };

  Drone.prototype.handleError = function(err) {
    if (err != null) {
      this.send(err.message);
      console.error(err.message, err.stack);
      return false;
    }
    return true;
  };

  Drone.prototype.send = function(message) {
    return this.client.write("" + message + "\n");
  };

  return Drone;

})();

module.exports = Drone;
